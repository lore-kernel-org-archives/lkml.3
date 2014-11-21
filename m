Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752543AbaKUVPU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 16:15:20 -0500
Received: from mga02.intel.com ([134.134.136.20]:64873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750822AbaKUVPT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 16:15:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,432,1413270000"; 
   d="scan'208";a="641401212"
Date: Fri, 21 Nov 2014 13:14:53 -0800 (PST)
From: Vikas Shivappa <vikas.shivappa@intel.com>
X-X-Sender: vikas@vshiva-Udesk
To: Borislav Petkov <bp@alien8.de>
cc: Vikas Shivappa <vikas.shivappa@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tj@kernel.org, matt.flemming@intel.com, will.auld@intel.com,
        peterz@infradead.org
Subject: Re: [PATCH] x86: Intel Cache Allocation Technology support
In-Reply-To: <20141121201520.GA5473@pd.tnic>
Message-ID: <alpine.DEB.2.10.1411211313200.30781@vshiva-Udesk>
References: <1416445539-24856-1-git-send-email-vikas.shivappa@linux.intel.com> <alpine.DEB.2.11.1411211224070.6439@nanos> <alpine.DEB.2.10.1411211123150.30781@vshiva-Udesk> <20141121201520.GA5473@pd.tnic>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 21 Nov 2014, Borislav Petkov wrote:

> On Fri, Nov 21, 2014 at 12:00:27PM -0800, Vikas Shivappa wrote:
>>>> +char hsw_brandstrs[5][64] = {
>>>> +			"Intel(R) Xeon(R)  CPU E5-2658 v3  @  2.20GHz",
>>>> +			"Intel(R) Xeon(R)  CPU E5-2648L v3  @  1.80GHz",
>>>> +			"Intel(R) Xeon(R)  CPU E5-2628L v3  @  2.00GHz",
>>>> +			"Intel(R) Xeon(R)  CPU E5-2618L v3  @  2.30GHz",
>>>> +			"Intel(R) Xeon(R)  CPU E5-2608L v3  @  2.00GHz"
>>>> +};
>>>> +
>>>> +#define cacheqe_for_each_child(child_cq, pos_css, parent_cq)		\
>>>> +	css_for_each_child((pos_css),	\
>>>> +	&(parent_cq)->css)
>>>> +
>>>> +#if CONFIG_CACHEQE_DEBUG
>>>
>>> We really do NOT need another config option for this. See above.
>>>
>>>> +/*DUMP the closid-cbm map.*/
>>>
>>> Wow that comment is really informative.
>>>
>>>> +static inline bool cqe_enabled(struct cpuinfo_x86 *c)
>>>> +{
>>>> +
>>>> +	int i;
>>>> +
>>>> +	if (cpu_has(c, X86_FEATURE_CQE_L3))
>>>> +		return true;
>>>> +
>>>> +	/*
>>>> +	 * Hard code the checks and values for HSW SKUs.
>>>> +	 * Unfortunately! have to check against only these brand name strings.
>>>> +	 */
>>>
>>> You must be kidding.
>>
>> No. Will have a microcode version check as well in next patch after thats
>> confirmed from h/w team
>
> Checking random brand strings? Please don't tell me those are not really
> immutable either...
>
> And what happens with newer models appearing? Add more brand strings?
> Lovely stuff, that.
>
> Well, since you're talking to the h/w team: can they give you some
> immutable bit somewhere which you can check instead of looking at brand
> strings? This'll be a sane solution, actually.
>

Yes , I did check for something like model stepping , not received anything yet. 
will update in my next version.

Thanks,
Vikas

> -- 
> Regards/Gruss,
>    Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
>
