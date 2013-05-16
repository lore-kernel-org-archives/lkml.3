Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab3EPQ0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 12:26:30 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:40794 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3EPQ02 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 12:26:28 -0400
MIME-Version: 1.0
In-Reply-To: <20130516160721.GP4072@tassilo.jf.intel.com>
References: <20130503121122.931661809@chello.nl>
	<20130503121256.083340271@chello.nl>
	<20130503143507.GP19487@tassilo.jf.intel.com>
	<20130503170007.GA30733@dyad.programming.kicks-ass.net>
	<CABPqkBSTMJebZLjvLhdQ1hiemoqvO2t=vi+CG=yLjkFabOr8XQ@mail.gmail.com>
	<20130515165152.GB13916@laptop.home>
	<CABPqkBSrLdXrg+p_A537O1mkv8Ewm-qt+0ugWOwJvLa6yn9ERg@mail.gmail.com>
	<20130516160721.GP4072@tassilo.jf.intel.com>
Date: Thu, 16 May 2013 18:26:27 +0200
Message-ID: <CABPqkBRxMj7QnaYtBKGEU2wRfS-KgiV3COoKAHCdJrj9BcJG=w@mail.gmail.com>
Subject: Re: [PATCH 1/3] perf, x86: Blacklist all MEM_*_RETIRED events for IVB
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 16, 2013 at 6:07 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> The difficulty is that we cannot use the shared_regs infrastructure because
>> the constraint is quite different. Here we need to say that if a mem event
>> uses cnt0 on one thread, then nothing can be using cnt0 on the other thread.
>> The current shared_regs infrastructure does not work on the counter level.
>> So we need to invent something else. It cannot even be extended.
>
> Just need a extra reg per counter, that is only triggered with that event.
>
Yes, it would be per counter and not per-event. But the check has to happen
after the assignment and each time we release the counter.

> -Andi
