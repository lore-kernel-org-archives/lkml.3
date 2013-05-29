Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966066Ab3E2TCa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 15:02:30 -0400
Received: from mga14.intel.com ([143.182.124.37]:33391 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759396Ab3E2TCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 15:02:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,765,1363158000"; 
   d="scan'208";a="248307559"
Message-ID: <51A650BC.7030604@intel.com>
Date: Wed, 29 May 2013 21:02:20 +0200
From: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>, Dave Hansen <dave.hansen@intel.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: possible_cpus broken in linux-next
References: <51A6367E.1060400@intel.com>  <1369852557.16819.54.camel@misato.fc.hp.com> <1369853414.16819.56.camel@misato.fc.hp.com>
In-Reply-To: <1369853414.16819.56.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="utf-8"; format="flowed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r4TJ2XXR012197

On 5/29/2013 8:50 PM, Toshi Kani wrote:
> On Wed, 2013-05-29 at 12:35 -0600, Toshi Kani wrote:
>> On Wed, 2013-05-29 at 10:10 -0700, Dave Hansen wrote:
>   :
>
>> Thanks for the report.  The following patch fixes the problem.
>> -Toshi
>>
>> ====
>> From: Toshi Kani <toshi.kani@hp.com>
>> Subject: [PATCH] ACPI: Fix sysfs cpu/online of offlined cpus
> Typo. The subject needs to be:
>
> Subject: [PATCH] cpu: Fix sysfs cpu/online of offlined cpus
>
> -Toshi
>
>> As reported by Dave Hansen, sysfs cpu/online shows 1 for
>> offlined cpus at boot.
>> https://lkml.org/lkml/2013/5/29/403
>>
>> Fix this problem by initializing dev.offline with cpu_online()
>> when registering a cpu.
>>
>> Reported-by: Dave Hansen <dave.hansen@intel.com>
>> Signed-off-by: Toshi Kani <toshi.kani@hp.com>

Thanks Toshi!

Dave, can you please confirm that the problem is fixed by this patch?

Rafael


>> ---
>>   drivers/base/cpu.c | 1 +
>>   1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
>> index 130ba0b..b9f0eec 100644
>> --- a/drivers/base/cpu.c
>> +++ b/drivers/base/cpu.c
>> @@ -281,6 +281,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
>>   	cpu->dev.bus = &cpu_subsys;
>>   	cpu->dev.release = cpu_device_release;
>>   	cpu->dev.offline_disabled = !cpu->hotpluggable;
>> +	cpu->dev.offline = !cpu_online(num);
>>   #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
>>   	cpu->dev.bus->uevent = arch_cpu_uevent;
>>   #endif
>

---------------------------------------------------------------------
Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
