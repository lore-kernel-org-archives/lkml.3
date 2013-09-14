Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753567Ab3INIpU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 04:45:20 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:9162 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab3INIpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 04:45:17 -0400
Message-ID: <52342190.1000409@huawei.com>
Date: Sat, 14 Sep 2013 16:42:56 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: lkml <linux-kernel@vger.kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] [RFC v2] seqcount: Add lockdep functionality to seqcount/seqlock
 structures
References: <1379117948-7385-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1379117948-7385-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/9/14 8:19, John Stultz wrote:
> Currently seqlocks and seqcounts don't support lockdep.
> 
> After running across a seqcount related deadlock in the timekeeping
> code, I used a less-refined and more focused varient of this patch
> to narrow down the cause of the issue.
> 
> This is a first-pass attempt to properly enable lockdep functionality
> on seqlocks and seqcounts.
> 
> Since seqcounts are used in the vdso gettimeofday code, I've provided
> lockdep accessors.
> 
> I've also handled one cases where there were nested seqlock writers
> and there may be more edge cases.
> 
> Comments and feedback would be appreciated!
> 

Could you describe how seqlocks/seqcounts can lead to deadlock in the
changelog?

> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
> v2:
>  * Update to new simplified lockdep.h
>  * vdso accessor simplifications
>  * removed needless preempt_disable
>  * removed unneeded ifdefs

