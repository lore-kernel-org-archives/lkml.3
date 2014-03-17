Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932257AbaCQDY4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 23:24:56 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:55751 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756095AbaCQDYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 23:24:55 -0400
Message-ID: <53266AFE.7020008@linaro.org>
Date: Mon, 17 Mar 2014 11:24:46 +0800
From: Alex Shi <alex.shi@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: mingo@redhat.com, peterz@infradead.org, morten.rasmussen@arm.com
CC: vincent.guittot@linaro.org, daniel.lezcano@linaro.org, fweisbec@gmail.com,
        linux@arm.linux.org.uk, tony.luck@intel.com, fenghua.yu@intel.com,
        james.hogan@imgtec.com, alex.shi@linaro.org, jason.low2@hp.com,
        viresh.kumar@linaro.org, hanjun.guo@linaro.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de,
        akpm@linux-foundation.org, arjan@linux.intel.com, pjt@google.com,
        fengguang.wu@intel.com, linaro-kernel@lists.linaro.org,
        wangyun@linux.vnet.ibm.com, mgorman@suse.de
Subject: Re: [ PATCH 0/8] sched: remove cpu_load array
References: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
In-Reply-To: <1394690249-14130-1-git-send-email-alex.shi@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2014 01:57 PM, Alex Shi wrote:
> In the cpu_load decay usage, we mixed the long term, short term load with
> balance bias, randomly pick a big/small value from them according to balance 
> destination or source. This mix is wrong, the balance bias should be based
> on task moving cost between cpu groups, not on random history or instant load.
> History load maybe diverage a lot from real load, that lead to incorrect bias.
> 
> In fact, the cpu_load decays can be replaced by the sched_avg decay, that 
> also decays load on time. The balance bias part can fullly use fixed bias --
> imbalance_pct, which is already used in newly idle, wake, forkexec balancing
> and numa balancing scenarios.
> 
> Currently the only working idx is busy_idx and idle_idx.
> As to busy_idx:
> We mix history load decay and bias together. The ridiculous thing is, when 
> all cpu load are continuous stable, long/short term load is same. then we 
> lose the bias meaning, so any minimum imbalance may cause unnecessary task
> moving. To prevent this funny thing happen, we have to reuse the 
> imbalance_pct again in find_busiest_group().  But that clearly causes over
> bias in normal time. If there are some burst load in system, it is more worse.
> 

Any comments?

> As to idle_idx:
> Though I have some cencern of usage corretion, 
> https://lkml.org/lkml/2014/3/12/247, but since we are working on cpu
> idle migration into scheduler. The problem will be reconsidered. We don't
> need to care it now.
> 
> This patch removed the cpu_load idx decay, since it can be replaced by
> sched_avg feature. and left the imbalance_pct bias untouched, since only 
> idle_idx missed it, but it is fine. and will be reconsidered soon.
> 
> 
> V5,
> 1, remove unify bias patch and biased_load function. Thanks for PeterZ's 
> comments!
> 2, remove get_sd_load_idx() in the 1st patch as SrikarD's suggestion.
> 3, remove LB_BIAS feature, it is not needed now.


-- 
Thanks
    Alex
