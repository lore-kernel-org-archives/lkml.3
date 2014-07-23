Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212AbaGWA7J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 20:59:09 -0400
Received: from mga14.intel.com ([192.55.52.115]:32572 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751143AbaGWA7H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 20:59:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,713,1400050800"; 
   d="scan'208";a="565780799"
Message-ID: <53CF08D7.7080908@intel.com>
Date: Wed, 23 Jul 2014 08:59:03 +0800
From: "Yan, Zheng" <zheng.z.yan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, a.p.zijlstra@chello.nl, mingo@kernel.org,
        acme@infradead.org, eranian@google.com
Subject: Re: [PATCH v3 5/9] perf, x86: large PEBS interrupt threshold
References: <1406016602-31845-1-git-send-email-zheng.z.yan@intel.com> <1406016602-31845-6-git-send-email-zheng.z.yan@intel.com> <20140722161617.GQ18735@two.firstfloor.org>
In-Reply-To: <20140722161617.GQ18735@two.firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2014 12:16 AM, Andi Kleen wrote:
>> +	/*
>> +	 * When the event is constrained enough we can use a larger
>> +	 * threshold and run the event with less frequent PMI.
>> +	 */
>> +	if (0 && /* disable this temporarily */
> 
> Where in the patchkit does it get reenabled?

enabled by patch 7
> 
> -Andi
> 
>> +	    (hwc->flags & PERF_X86_EVENT_AUTO_RELOAD) &&
>> +	    !(event->attr.sample_type & ~PEBS_FREERUNNING_FLAGS)) {
>> +		threshold = ds->pebs_absolute_maximum -
>> +			x86_pmu.max_pebs_events * x86_pmu.pebs_record_size;
>> +	} else {
>> +		threshold = ds->pebs_buffer_base + x86_pmu.pebs_record_size;
>> +	}
>> +	if (first_pebs || ds->pebs_interrupt_threshold > threshold)
>> +		ds->pebs_interrupt_threshold = threshold;

