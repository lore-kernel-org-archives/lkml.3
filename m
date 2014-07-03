Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755037AbaGCFrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:47:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:50110 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751733AbaGCFrR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:47:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,593,1400050800"; 
   d="scan'208";a="538121595"
Message-ID: <53B4EE63.3000507@intel.com>
Date: Thu, 03 Jul 2014 13:47:15 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 02/16] perf, core: introduce pmu context switch callback
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com> <1404118253-19532-3-git-send-email-zheng.z.yan@intel.com> <20140702101216.GV6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140702101216.GV6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 06:12 PM, Peter Zijlstra wrote:
> On Mon, Jun 30, 2014 at 04:50:39PM +0800, Yan, Zheng wrote:
>> @@ -2362,6 +2363,58 @@ unlock:
>>  	}
>>  }
>>  
>> +void perf_sched_cb_disable(struct pmu *pmu)
>> +{
>> +	__get_cpu_var(perf_sched_cb_usages)--;
>> +}
>> +
>> +void perf_sched_cb_enable(struct pmu *pmu)
>> +{
>> +	__get_cpu_var(perf_sched_cb_usages)++;
>> +}
> 
> Those should not be called {dis,en}able, they don't as such do that.

I can't think up a better name. what should they be called?

Regards
Yan, Zheng

> Also we have: this_cpu_{inc,dec} for this.
> 

