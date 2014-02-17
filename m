Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754133AbaBQSgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 13:36:43 -0500
Received: from service87.mimecast.com ([91.220.42.44]:50288 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752894AbaBQSgm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 13:36:42 -0500
Message-ID: <530256CB.6000603@arm.com>
Date: Mon, 17 Feb 2014 18:36:59 +0000
From: Sudeep Holla <Sudeep.Holla@arm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Sudeep.Holla@arm.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        "linux390@de.ibm.com" <linux390@de.ibm.com>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>
Subject: Re: [PATCH RFC/RFT v2 3/8] s390: move cacheinfo sysfs to generic
 cacheinfo infrastructure
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com> <1391791763-28518-4-git-send-email-sudeep.holla@arm.com> <20140210113019.GC19013@osiris>
In-Reply-To: <20140210113019.GC19013@osiris>
X-OriginalArrivalTime: 17 Feb 2014 18:36:40.0670 (UTC) FILETIME=[32DFE7E0:01CF2C0F]
X-MC-Unique: 114021718364004701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Heiko,

On 10/02/14 11:30, Heiko Carstens wrote:
> On Fri, Feb 07, 2014 at 04:49:18PM +0000, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch removes the redundant sysfs cacheinfo code by making use of
>> the newly introduced generic cacheinfo infrastructure.
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
> 
> [...]
> 
>> -static ssize_t shared_cpu_map_func(struct kobject *kobj, int type, char *buf)
>> -{
>> -	struct cache_index_dir *index;
>> -	int len;
>> +	this_leaf->level = level + 1;
>> +	this_leaf->type = type;
>> +	this_leaf->coherency_line_size = ecag(EXTRACT_LINE_SIZE, level, ti);
>> +	this_leaf->ways_of_associativity = ecag(EXTRACT_ASSOCIATIVITY,
>> +						level, ti);
>> +	this_leaf->size = ecag(EXTRACT_SIZE, level, ti);
>> +	if (private)
>> +		cpumask_set_cpu(cpu, &this_leaf->shared_cpu_map);
>> +	else /* System wide */
>> +		cpumask_copy(&this_leaf->shared_cpu_map, cpu_online_mask);
> 
> FWIW, this also seems to be wrong: on s390 we only expose cpu private
> caches via sysfs. Shared caches are not exposed (and simply saying they are
> system wide would be wrong).
> Please have a look at these two commits which should describe why things
> are as they are on s390:
> 
> 881730ad365130f64b5c70c40904b04eb3b79de3
>  "s390/cache: expose cpu cache topology via sysfs"
> 6668022c7bde3fdc96d3d257294a7216c7a46829
>  "s390/cache: add cpu cache information to /proc/cpuinfo"
> 
>

I need your help to get few things clarified.

IIUC, I see that shared caches are not exposed via sysfs but there are exposed
through /proc/cpuinfo, right ? If yes, based on your above statement, shared
cpus are may not be system-wide, then how can /proc/cpuinfo show shared cache info.

Regards,
Sudeep

