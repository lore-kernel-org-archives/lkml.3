Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882AbaIVVnD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 17:43:03 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:50272 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbaIVVmr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 17:42:47 -0400
MIME-Version: 1.0
In-Reply-To: <20140922200806.GC3128@worktop.programming.kicks-ass.net>
References: <1411414762-32366-1-git-send-email-bobby.prani@gmail.com> <20140922200806.GC3128@worktop.programming.kicks-ass.net>
From: Pranith Kumar <bobby.prani@gmail.com>
Date: Mon, 22 Sep 2014 17:42:16 -0400
Message-ID: <CAJhHMCC7RKE9GE3fGx0pnNoZHL0r_MOPMPwCjjNNbnC6i0G=BA@mail.gmail.com>
Subject: Re: [RFC PATCH] x86: Use volatile semantics for atomic_set()
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "open list:X86 ARCHITECTURE..." <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 4:08 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Sep 22, 2014 at 03:39:21PM -0400, Pranith Kumar wrote:
>> All the atomic operations have volatile semantics to prevent compiler
>> reordering. Enforce the same semantics for atomic_set() too.
>
> To what point? atomic_set() is typically not what you expect it to
> anyhow.

This is the only atomic operation which allows compiler reordering. I
am not sure why this exception was made. Any ideas as to why we do
this?

As I mentioned, this patch removes this inconsistency by disallowing
compiler reordering.

-- 
Pranith
