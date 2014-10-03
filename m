Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396AbaJCXsW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 19:48:22 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:34987 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933376AbaJCXsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 19:48:18 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrVVeuVc7JC7w3Z_2pCx0y_HAFtm4=FmEp_xNkn3tvnR+A@mail.gmail.com>
References: <20140921184153.GA23727@redhat.com>
	<tip-0ad6e3c5199be12c9745da8f8b9e3c9f8066c235@git.kernel.org>
	<542E2B05.5080607@oracle.com>
	<20141003083954.10a13a24@as>
	<20141003214124.GA31614@redhat.com>
	<CALCETrVVeuVc7JC7w3Z_2pCx0y_HAFtm4=FmEp_xNkn3tvnR+A@mail.gmail.com>
Date: Fri, 3 Oct 2014 16:48:17 -0700
X-Google-Sender-Auth: hTOnf636kkKVHq5BHjfT5OGwS0U
Message-ID: <CA+55aFx7n9nsfMYELGN0Kev13pHUgzMBtPyovyBf8-LUYTC9bg@mail.gmail.com>
Subject: Re: [tip:x86/asm] x86: Speed up ___preempt_schedule*() by using THUNK helpers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Oleg Nesterov <oleg@redhat.com>, Chuck Ebbert <cebbert.lkml@gmail.com>,
        Sasha Levin <sasha.levin@oracle.com>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Denys Vlasenko <dvlasenk@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 3, 2014 at 2:56 PM, Andy Lutomirski <luto@amacapital.net> wrote:
>
> Is this thing missing a flags or cc clobber:
>
> # define __preempt_schedule() asm ("call ___preempt_schedule")

Yes, it should probably have a cc clobber. Although I think thet gcc
actually assumes all asms clobber flags on x86, so it shouldn't
matter.

> Is this all just to make the call sequence for preempt_schedule shorter?

Not so much the call sequence, but the code around the call - not
havign to spill live registers etc. But yes.

              Linus
