Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3EVI7l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 04:59:41 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:55974 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753404Ab3EVI7j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 04:59:39 -0400
Message-ID: <519C88D9.30009@linux.vnet.ibm.com>
Date: Wed, 22 May 2013 14:29:05 +0530
From: Anshuman Khandual <khandual@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michael Ellerman <michael@ellerman.id.au>
CC: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, mikey@neuling.org
Subject: Re: [PATCH 1/2] powerpc, perf: Ignore separate BHRB privilege state
 filter request
References: <1369201667-9048-1-git-send-email-khandual@linux.vnet.ibm.com> <1369201667-9048-2-git-send-email-khandual@linux.vnet.ibm.com> <1369206855.12874.9.camel@concordia>
In-Reply-To: <1369206855.12874.9.camel@concordia>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13052208-4790-0000-0000-0000086A4526
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Your description from patch 0 should be here.
>

Sure, will bring it here.

> 
>> diff --git a/arch/powerpc/perf/power8-pmu.c b/arch/powerpc/perf/power8-pmu.c
>> index f7d1c4f..8ed323d 100644
>> --- a/arch/powerpc/perf/power8-pmu.c
>> +++ b/arch/powerpc/perf/power8-pmu.c
>> @@ -525,16 +525,17 @@ static u64 power8_bhrb_filter_map(u64 branch_sample_type)
>>  	u64 pmu_bhrb_filter = 0;
>>  	u64 br_privilege = branch_sample_type & ONLY_PLM;
>>  
>> -	/* BHRB and regular PMU events share the same prvillege state
>> +	/* BHRB and regular PMU events share the same prvilege state
> 
> Please spell "privilege" correctly.
> 

My bad, will fix it.


>>  	 * filter configuration. BHRB is always recorded along with 
> It still says "privilege state filter criteria for the BHRB and the
> companion PMU events has to be the same".
> 
> But they don't, right?
> 

Right


> What it should say is "we ignore the privilege bits in the branch sample
> type because they are handled by the underlying PMC configuration" - or
> something like that.

Here is the latest description for the code block

	/* BHRB and regular PMU events share the same privilege state
	 * filter configuration. BHRB is always recorded along with a
	 * regular PMU event. As the privilege state filter is handled
	 * in the basic PMC configuration of the accompanying regular
	 * PMU event, we ignore any separate BHRB specific request.
	 */

Does it sound better ?

> 
>> -	if ((br_privilege != 7) && (br_privilege != 0))
>> -		return -1;
>> +
>> +	if (br_privilege)
>> +		pr_info("BHRB privilege state filter request %llx ignored\n",
>> +								br_privilege);
> 
> Don't do that. Ignoring the br_privilege is either the right thing to do
> in which case we do it and print nothing,


I thought the informational print would at least make the user aware
of the fact that the separate filter request for BHRB went ignored.
Can we add this some where in the documentation ?

  
 or it doesn't make sense and
> we reject it.
>

 
> cheers
> 

