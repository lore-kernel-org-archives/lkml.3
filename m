Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753030AbaBTOgj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 09:36:39 -0500
Received: from service87.mimecast.com ([91.220.42.44]:46045 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbaBTOgg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 09:36:36 -0500
Message-ID: <53061311.9000800@arm.com>
Date: Thu, 20 Feb 2014 14:37:05 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Sudeep.Holla@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v3 4/9] s390: move cacheinfo sysfs to generic
 cacheinfo infrastructure
References: <1392825976-17633-1-git-send-email-sudeep.holla@arm.com> <1392825976-17633-5-git-send-email-sudeep.holla@arm.com> <20140220083816.GA4203@osiris> <53060444.9010308@arm.com> <20140220140727.GD4203@osiris>
In-Reply-To: <20140220140727.GD4203@osiris>
X-OriginalArrivalTime: 20 Feb 2014 14:36:37.0959 (UTC) FILETIME=[296DDD70:01CF2E49]
X-MC-Unique: 114022014363406001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20/02/14 14:07, Heiko Carstens wrote:
> On Thu, Feb 20, 2014 at 01:33:56PM +0000, Sudeep Holla wrote:
>> Thanks, this info was helpful and looks like it's stupid mistake I did. I
>> deleted a line unknowingly while trying to minimise the diff for show_cacheinfo.
>> The below fix-up must work IIUC the issue. I will squash this in my next update
>> if it works.
>>
>> Regards,
>> Sudeep
>>
>> --->8
>>
>> From 77690bc34b2b4b492377998019371f6e2f8f90b7 Mon Sep 17 00:00:00 2001
>> From: Sudeep Holla <sudeep.holla@arm.com>
>> Date: Thu, 20 Feb 2014 13:14:09 +0000
>> Subject: [PATCH] fixup! s390: move cacheinfo sysfs to generic cacheinfo
>>  infrastructure
>>
>> ---
>>  arch/s390/kernel/cache.c | 5 +++--
>>  1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/s390/kernel/cache.c b/arch/s390/kernel/cache.c
>> index e064f95..aeedb7f 100644
>> --- a/arch/s390/kernel/cache.c
>> +++ b/arch/s390/kernel/cache.c
>> @@ -68,14 +68,15 @@ void show_cacheinfo(struct seq_file *m)
>>  {
>>  	int cpu = smp_processor_id(), idx;
>>  	struct cpu_cacheinfo *this_cpu_ci = get_cpu_cacheinfo(cpu);
>> -	struct cache_info *cache = this_cpu_ci->info_list;
>> +	struct cache_info *cache;
>>
>>  	for (idx = 0; idx < this_cpu_ci->num_leaves; idx++) {
>> +		cache = this_cpu_ci->info_list + idx;
>>  		seq_printf(m, "cache%-11d: ", idx);
>>  		seq_printf(m, "level=%d ", cache->level);
>>  		seq_printf(m, "type=%s ", cache_type_string[cache->type]);
>>  		seq_printf(m, "scope=%s ",
>> -			   cache->disable_sysfs ? "Private" : "Shared");
>> +			   cache->disable_sysfs ? "Shared" : "Private");
>>  		seq_printf(m, "size=%dK ", cache->size >> 10);
>>  		seq_printf(m, "line_size=%u ", cache->coherency_line_size);
>>  		seq_printf(m, "associativity=%d", cache->ways_of_associativity);
> 
> With this patch applied the output looks ok again.
> 

Thanks a lot for retesting and confirming results with this fix-up, will squash
it in my next update.

Regards,
Sudeep

