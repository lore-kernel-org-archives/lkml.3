Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752637AbaKUV13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:27:29 -0500
Received: from mga14.intel.com ([192.55.52.115]:47408 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaKUV11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:27:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="419988640"
Date: Fri, 21 Nov 2014 13:27:13 -0800 (PST)
From: Vikas Shivappa <vikas.shivappa@intel.com>
X-X-Sender: vikas@vshiva-Udesk
To: Thomas Gleixner <tglx@linutronix.de>
cc: Dave Hansen <dave.hansen@intel.com>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, vikas.shivappa@intel.com, hpa@zytor.com,
        mingo@kernel.org, tj@kernel.org, Matt Fleming <matt.fleming@intel.com>,
        "Auld, Will" <will.auld@intel.com>, peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
In-Reply-To: <alpine.DEB.2.11.1411212139360.6439@nanos>
Message-ID: <alpine.DEB.2.10.1411211326080.30781@vshiva-Udesk>
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com> <546FA0C4.1000402@intel.com> <alpine.DEB.2.11.1411212139360.6439@nanos>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Nov 2014, Thomas Gleixner wrote:

> On Fri, 21 Nov 2014, Dave Hansen wrote:
>> On 11/19/2014 05:05 PM, Vikas Shivappa wrote:
>>> +	/*
>>> +	 * Hard code the checks and values for HSW SKUs.
>>> +	 * Unfortunately! have to check against only these brand name strings.
>>> +	 */
>>> +
>>> +	for (i = 0; i < 5; i++)
>>> +		if (!strcmp(hsw_brandstrs[i], c->x86_model_id)) {
>>> +			c->x86_cqe_closs = 4;
>>> +			c->x86_cqe_cbmlength = 20;
>>> +			return true;
>>> +		}
>>
>> Please use ARRAY_SIZE() here.  Otherwise, I guarantee the next string
>> you add to hsw_brandstrs[] gets silently ignored.
>>
>> Are there really only 5 CPUs?  This:
>>
>>> http://ark.intel.com/products/family/78583/Intel-Xeon-Processor-E5-v3-Family#@Server
>>
>> lists 32 skus.
>
> We really should find a proper software probing solution for this
> instead of having a gazillion of brand strings plus micro code version
> checks around for this.
>
> Why cant the HW folks release a micro code version which fixes the
> obviously wreckaged CPUID enumeration of this feature instead of
> burdening us with that horror?
>
> Can you please find a proper sized clue bat and whack your HW folks
> over the head for this insanity?
Ok , we were in the process of checking this as its not usual to make 5 
expensive brand strings. Will update status in next version.

Thanks,
Vikas
>
> Thanks,
>
> 	tglx
>
