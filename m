Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752700AbaBJLem (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 06:34:42 -0500
Received: from service87.mimecast.com ([91.220.42.44]:45321 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaBJLei convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 06:34:38 -0500
Message-ID: <52F8B95F.5030401@arm.com>
Date: Mon, 10 Feb 2014 11:34:55 +0000
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
References: <1391791763-28518-1-git-send-email-sudeep.holla@arm.com> <1391791763-28518-4-git-send-email-sudeep.holla@arm.com> <20140210095020.GB19013@osiris>
In-Reply-To: <20140210095020.GB19013@osiris>
X-OriginalArrivalTime: 10 Feb 2014 11:34:36.0290 (UTC) FILETIME=[1379EE20:01CF2654]
X-MC-Unique: 114021011343613001
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/02/14 09:50, Heiko Carstens wrote:
> On Fri, Feb 07, 2014 at 04:49:18PM +0000, Sudeep Holla wrote:
>> From: Sudeep Holla <sudeep.holla@arm.com>
>>
>> This patch removes the redundant sysfs cacheinfo code by making use of
>> the newly introduced generic cacheinfo infrastructure.
>>
>> Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
>> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
>> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
>> Cc: linux390@de.ibm.com
>> Cc: linux-s390@vger.kernel.org
>> ---
> 
> [...]
> 
>> diff --git a/arch/s390/kernel/processor.c b/arch/s390/kernel/processor.c
>> index 2461202..1f875db 100644
>> --- a/arch/s390/kernel/processor.c
>> +++ b/arch/s390/kernel/processor.c
>> @@ -58,7 +58,6 @@ static int show_cpuinfo(struct seq_file *m, void *v)
>>  			if (hwcap_str[i] && (elf_hwcap & (1UL << i)))
>>  				seq_printf(m, "%s ", hwcap_str[i]);
>>  		seq_puts(m, "\n");
>> -		show_cacheinfo(m);
>>  	}
>>  	get_online_cpus();
>>  	if (cpu_online(n)) {
> 
> You can't remove that. It's a user space visible change.
> 
Correct, I wanted to add show_cacheinfo back as its user ABI already, missed it.

Is it ok if I use cpu0 cacheinfo or to be safer as cpu0 can be offline, use
the cacheinfo of the cpu executing this ?

Regards,
Sudeep


