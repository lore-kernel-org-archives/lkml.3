Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab3LNN2M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 08:28:12 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:53956 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab3LNN2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 08:28:10 -0500
Message-ID: <52AC5CDF.8050209@linaro.org>
Date: Sat, 14 Dec 2013 21:27:59 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@redhat.com, morten.rasmussen@arm.com, vincent.guittot@linaro.org,
        daniel.lezcano@linaro.org, fweisbec@gmail.com, linux@arm.linux.org.uk,
        tony.luck@intel.com, fenghua.yu@intel.com, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, james.hogan@imgtec.com, jason.low2@hp.com,
        gregkh@linuxfoundation.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] sched: remove cpu_load decay
References: <1386061556-28233-1-git-send-email-alex.shi@linaro.org> <20131213200303.GI2480@laptop.programming.kicks-ass.net>
In-Reply-To: <20131213200303.GI2480@laptop.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2013 04:03 AM, Peter Zijlstra wrote:
> 
> 
> I had a quick peek at the actual patches.
> 
> afaict we're now using weighted_cpuload() aka runnable_load_avg as the
> ->cpu_load. Whatever happened to also using the blocked_avg?

When enabling the sched_avg in load balance, I didn't find any positive
testing result for several blocked_avg trying, just few regression. :(

And since this patchset is almost clean up only, no blocked_load_avg
trying again...

> 
> I totally hate patch 4; it seems like a random hack to make up for the
> lack of blocked_avg.

Yes, this bias criteria seems a bit arbitrary. :)
But, anyway even with blocked_load_avg, we still need to consider to
bias to local cpu. like in a scenario, 2 cpus both has nearly zero
blocked_load_avg.

BTW,

Paul, do you has new idea on blocked_load_avg using?

-- 
Thanks
    Alex
