Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838AbaJHREF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 13:04:05 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:51001 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaJHREC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 13:04:02 -0400
MIME-Version: 1.0
In-Reply-To: <1412782664.5179.75.camel@marge.simpson.net>
References: <20141003194428.GA27084@sesse.net>
	<1412782664.5179.75.camel@marge.simpson.net>
Date: Wed, 8 Oct 2014 13:04:01 -0400
X-Google-Sender-Auth: gIlY9cAgzj74fcE_r5EPmJYZpQY
Message-ID: <CA+55aFyuH07zzD6dD4k0pdyvJ7fUhFdFrmPYJi9W=FtHihgndA@mail.gmail.com>
Subject: Re: bisected: futex regression >= 3.14 - was - Slowdown due to
 threads bouncing between HT cores
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: "Steinar H. Gunderson" <sgunderson@bigfoot.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 8, 2014 at 11:37 AM, Mike Galbraith
<umgwanakikbuti@gmail.com> wrote:
>
> 11d4616bd07f38d496bd489ed8fad1dc4d928823 is the first bad commit
> commit 11d4616bd07f38d496bd489ed8fad1dc4d928823
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Mar 20 22:11:17 2014 -0700
>
>     futex: revert back to the explicit waiter counting code

While that revert might make things a tiny bit slower (I hated doing
it, but the clever approach sadly didn't work on powerpc and depended
on x86 locking semantics), I seriously doubt it's really relevant.
It's more likely that the *real* problem itself is very
timing-dependent, and the subtle synchronization changes here then
expose it or hide it, rather than really fixing anything.

So like Thomas, I would suspect a race condition in the futex use, and
then the exact futex implementation details are just exposing it
incidentally.

               Linus
