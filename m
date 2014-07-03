Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657AbaGCF75 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:59:57 -0400
Received: from mga09.intel.com ([134.134.136.24]:52217 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750859AbaGCF74 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:59:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,593,1400050800"; 
   d="scan'208";a="538125116"
Message-ID: <53B4F159.9020102@intel.com>
Date: Thu, 03 Jul 2014 13:59:53 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 07/16] perf, x86: track number of events that use LBR
 callstack
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com> <1404118253-19532-8-git-send-email-zheng.z.yan@intel.com> <20140702102147.GZ6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140702102147.GZ6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 06:21 PM, Peter Zijlstra wrote:
> On Mon, Jun 30, 2014 at 04:50:44PM +0800, Yan, Zheng wrote:
>> +static inline bool branch_user_callstack(unsigned br_sel)
>> +{
>> +	return (br_sel & X86_BR_USER) && (br_sel & X86_BR_CALL_STACK);
>> +}
>> +
>>  void intel_pmu_lbr_enable(struct perf_event *event)
>>  {
>>  	struct cpu_hw_events *cpuc = &__get_cpu_var(cpu_hw_events);
>> +	struct x86_perf_task_context *task_ctx;
>>  
>>  	if (!x86_pmu.lbr_nr)
>>  		return;
>> @@ -214,6 +220,10 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>>  	}
>>  	cpuc->br_sel = event->hw.branch_reg.reg;
>>  
>> +	task_ctx = event->ctx ? event->ctx->task_ctx_data : NULL;
>> +	if (branch_user_callstack(cpuc->br_sel))
>> +		task_ctx->lbr_callstack_users++;
>> +
> 
> So what happens if we make a per-cpu event which satisfies
> branch_user_callstack() ?
> 

So far only per-process event can satisfy branch_user_callstack(). I will fix the potential null pointer dereference.

Regards
Yan，Zheng

