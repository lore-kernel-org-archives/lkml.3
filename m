Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3IQI2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 04:28:12 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:53022 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab3IQI2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 04:28:08 -0400
Date: Tue, 17 Sep 2013 10:28:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizefan@huawei.com>, Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] [RFC v2] seqcount: Add lockdep functionality to
 seqcount/seqlock structures
Message-ID: <20130917082805.GF20661@gmail.com>
References: <1379117948-7385-1-git-send-email-john.stultz@linaro.org>
 <5237A11C.1080408@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5237A11C.1080408@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* John Stultz <john.stultz@linaro.org> wrote:

> On 09/13/2013 05:19 PM, John Stultz wrote:
> > Currently seqlocks and seqcounts don't support lockdep.
> >
> > After running across a seqcount related deadlock in the timekeeping
> > code, I used a less-refined and more focused varient of this patch
> > to narrow down the cause of the issue.
> >
> > This is a first-pass attempt to properly enable lockdep functionality
> > on seqlocks and seqcounts.
> >
> > Since seqcounts are used in the vdso gettimeofday code, I've provided
> > lockdep accessors.
> >
> > I've also handled one cases where there were nested seqlock writers
> > and there may be more edge cases.
> 
> Oof.
> 
> So I just noticed there's a bunch of places in the network code that use
> fairly deeply embedded seqcounter: u64_stats_sync. There's almost never
> an explicit initialization, as they assume they're zeroed when
> allocated, but this causes trouble with the lockdep key initialization.
> 
> I'll have to go through each of these (about 25 cases) and make them
> call seqcount_init(), but since I'm heading to plumbers tomorrow I might
> not get to it until next week.
> 
> Anyway, let me know if you have any other thoughts on the patches.

Explicit initialization is generally a bonus for readability, 
debuggability and ease of development, we enforce that for spinlocks as 
well.

Thanks,

	Ingo
