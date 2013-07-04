Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756562Ab3GDLjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 07:39:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:49007 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752996Ab3GDLjG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 07:39:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,994,1363158000"; 
   d="scan'208";a="364742178"
Message-ID: <51D55ED4.5030405@intel.com>
Date: Thu, 04 Jul 2013 19:39:00 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130514 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, eranian@google.com,
        andi@firstfloor.org
Subject: Re: [PATCH v2 4/7] perf, x86: Save/resotre LBR stack during context
 switch
References: <1372663387-11754-1-git-send-email-zheng.z.yan@intel.com> <1372663387-11754-5-git-send-email-zheng.z.yan@intel.com> <20130704095735.GL18898@dyad.programming.kicks-ass.net>
In-Reply-To: <20130704095735.GL18898@dyad.programming.kicks-ass.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2013 05:57 PM, Peter Zijlstra wrote:
> On Mon, Jul 01, 2013 at 03:23:04PM +0800, Yan, Zheng wrote:
>> +++ b/arch/x86/kernel/cpu/perf_event_intel_lbr.c
>> @@ -185,6 +185,13 @@ void intel_pmu_lbr_reset(void)
>>  		intel_pmu_lbr_reset_32();
>>  	else
>>  		intel_pmu_lbr_reset_64();
>> +
>> +	wrmsrl(x86_pmu.lbr_tos, 0);
>> +}
> 
> I double checked; my SDM Jun 2013, Vol 3C 35-93 very explicitly states that
> MSR_LASTBRANCH_TOS is a read-only MSR. And afaicr all previous times I checked
> this it did say this too.
> 

thank you for point out this. I will update the patch

Yan, Zheng
