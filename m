Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaAJB7h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 20:59:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:52608 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751745AbaAJB7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 20:59:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,635,1384329600"; 
   d="scan'208";a="456440371"
Message-ID: <52CF5402.70106@linux.intel.com>
Date: Fri, 10 Jan 2014 09:59:30 +0800
From: Jiang Liu <jiang.liu@linux.intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (Windows NT 6.2; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Len Brown <len.brown@intel.com>, Len Brown <lenb@kernel.org>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] intel_idle: close avn_cstates array with correct
 marker
References: <1389252628-1033-1-git-send-email-jiang.liu@linux.intel.com> <1389252628-1033-2-git-send-email-jiang.liu@linux.intel.com> <5913087.iUSSiA9xVP@vostro.rjw.lan>
In-Reply-To: <5913087.iUSSiA9xVP@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2014/1/9 21:31, Rafael J. Wysocki wrote:
> On Thursday, January 09, 2014 03:30:27 PM Jiang Liu wrote:
>> Close avn_cstates array with correct marker to avoid overflow
>> in function intel_idle_cpu_init().
>>
>> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
>> Cc: <stable@vger.kernel.org> # 3.13
> 
> Why did you mark it for 3.13-stable?  3.13 hasn't been released yet, so this
> can be pushed for 3.13 still.
> 
> Is the problem present in 3.13-rc?  If so, has it been introduced by any
> recent commits or was it there before?  In which case, do we need this patch
> in stable as well?
> 
> Rafael
Hi Rafael,
	This issue is introduced in 3.13-rc2, and I feel it's too late
to catch up with 3.13 window, so mark it for 3.13 speculatively.
	After more thoughts, I feel this patch should be divided into
two patches.
	One is to temporarily remove the __initdata marker. The other
is to correctly mark end of avn_cstates array. The second bug should
be introduced when merging "22e580d intel_idle: Fixed C6 state on
Avoton/Rangeley processors" with "eba682a intel_idle: shrink states tables".
	Should I split it into two?
Thanks!
Gerry

> 
> 
>> ---
>>  drivers/idle/intel_idle.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/idle/intel_idle.c b/drivers/idle/intel_idle.c
>> index 6f456f0..797ed29 100644
>> --- a/drivers/idle/intel_idle.c
>> +++ b/drivers/idle/intel_idle.c
>> @@ -329,7 +329,7 @@ static struct cpuidle_state atom_cstates[] = {
>>  	{
>>  		.enter = NULL }
>>  };
>> -static struct cpuidle_state avn_cstates[] __initdata = {
>> +static struct cpuidle_state avn_cstates[] = {
>>  	{
>>  		.name = "C1-AVN",
>>  		.desc = "MWAIT 0x00",
>> @@ -344,6 +344,8 @@ static struct cpuidle_state avn_cstates[] __initdata = {
>>  		.exit_latency = 15,
>>  		.target_residency = 45,
>>  		.enter = &intel_idle },
>> +	{
>> +		.enter = NULL }
>>  };
>>  
>>  /**
>>
> 
