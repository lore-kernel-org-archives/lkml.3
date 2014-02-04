Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204AbaBDQ3l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 11:29:41 -0500
Received: from mail-vb0-f45.google.com ([209.85.212.45]:57649 "EHLO
	mail-vb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaBDQ3h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 11:29:37 -0500
MIME-Version: 1.0
In-Reply-To: <20140204122212.GO8874@twins.programming.kicks-ass.net>
References: <20140204122212.GO8874@twins.programming.kicks-ass.net>
Date: Tue, 4 Feb 2014 08:29:36 -0800
X-Google-Sender-Auth: aPZUOkizMvRmnkXI2TQ0KwKkChA
Message-ID: <CA+55aFz6LGt35C2ex6qCM8cQDowmr9HR-+hR9bMXJPE707+k-A@mail.gmail.com>
Subject: Re: [RFC][PATCH] ia64: Fix atomic ops vs memory barriers
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Will Deacon <will.deacon@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 4, 2014 at 4:22 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
> The below patch assumes the SDM is right (TM), and fixes the atomic_t,
> cmpxchg() and xchg() implementations by inserting a mf before the
> cmpxchg.acq (or xchg).

You picked the wrong thing to be right. The SDM is wrong.

Last time this came up, Tony explained it thus:

>> Worse still - early processor implementations actually just ignored
>> the acquire/release and did a full fence all the time.  Unfortunately
>> this meant a lot of badly written code that used .acq when they really
>> wanted .rel became legacy out in the wild - so when we made a cpu
>> that strictly did the .acq or .rel ... all that code started breaking - so
>> we had to back-pedal and keep the "legacy" behavior of a full fence :-(

and since ia64 is basically on life support as an architecture, we can
pretty much agree that the SDM is dead, and the only thing that
matters is implementation.

The above quote was strictly in the context of just cmpxchg, though,
so it's possible that the "fetchadd" instruction acts differently. I
would personally expect it to have the same issues, but let's see what
Tony says.. Tony?

                Linus
