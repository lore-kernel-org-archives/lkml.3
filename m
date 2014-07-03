Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaGCFpF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 01:45:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:49753 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817AbaGCFpD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 01:45:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,593,1400050800"; 
   d="scan'208";a="538120849"
Message-ID: <53B4EDD0.8080003@intel.com>
Date: Thu, 03 Jul 2014 13:44:48 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, acme@infradead.org,
        eranian@google.com, andi@firstfloor.org
Subject: Re: [PATCH V4 03/16] perf, x86: use context switch callback to flush
 LBR stack
References: <1404118253-19532-1-git-send-email-zheng.z.yan@intel.com> <1404118253-19532-4-git-send-email-zheng.z.yan@intel.com> <20140702090638.GU6758@twins.programming.kicks-ass.net>
In-Reply-To: <20140702090638.GU6758@twins.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/02/2014 05:06 PM, Peter Zijlstra wrote:
> On Mon, Jun 30, 2014 at 04:50:40PM +0800, Yan, Zheng wrote:
>> @@ -185,6 +185,23 @@ void intel_pmu_lbr_enable(struct perf_event *event)
>>  		return;
>>  
>>  	/*
>> +	 * It is necessary to flush the stack on context switch. This happens
>> +	 * when the branch stack does not tag its entries with the pid of the
>> +	 * current task.
> 
> Did you mean to say: "This happens _because_ the branch stack does not
> tag its entries with the pid of the current task." ?

yes. The comment is copied from comments of perf_branch_stack_sched_in()

Regards
Yan, Zheng

> 
>> +	 */
>> +	if (sched_in) {
>> +		intel_pmu_lbr_reset();
>> +		cpuc->lbr_context = ctx;
>> +	}
>> +}

