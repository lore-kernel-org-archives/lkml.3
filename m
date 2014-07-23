Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466AbaGWFh2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:37:28 -0400
Received: from mga11.intel.com ([192.55.52.93]:37472 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750913AbaGWFh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:37:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,715,1400050800"; 
   d="scan'208";a="565865280"
Message-ID: <53CF499D.7020304@intel.com>
Date: Wed, 23 Jul 2014 13:35:25 +0800
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: lenb@kernel.org, linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI/NVS: Not save NVS region for new machines to accelerate
 S3
References: <1405662922-23606-1-git-send-email-tianyu.lan@intel.com> <1466357.PZLf9xnT2g@vostro.rjw.lan>
In-Reply-To: <1466357.PZLf9xnT2g@vostro.rjw.lan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年07月23日 07:40, Rafael J. Wysocki wrote:
> On Friday, July 18, 2014 01:55:22 PM Lan Tianyu wrote:
>> NVS region is saved and restored unconditionally for machines without
>> nvs_nosave quirk during S3. Tested some new machines and the operation
>> is not necessary. Saving NVS region also affects S2RAM speed. The time of
>> NVS saving and restoring depends on the size of NVS region and it consumes
>> 7~10ms normally.
>>
>> This patch is to make machines produced from 2012 to now not saving NVS region
>> to accelerate S3.
>>
>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>> ---
>>  drivers/acpi/sleep.c | 5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
>> index b3e3cc7..896d8be 100644
>> --- a/drivers/acpi/sleep.c
>> +++ b/drivers/acpi/sleep.c
>> @@ -322,7 +322,12 @@ static struct dmi_system_id acpisleep_dmi_table[] __initdata = {
>>  
>>  static void acpi_sleep_dmi_check(void)
>>  {
>> +	int year;
>> +
>>  	dmi_check_system(acpisleep_dmi_table);
>> +
>> +	if (dmi_get_date(DMI_BIOS_DATE, &year, NULL, NULL) && year >= 2012)
>> +		acpi_nvs_nosave_s3();
> 
> I'd prefer the ordering here to be different so that individual quirks
> could be used to change the date-based wholesale behavior.

Ok. I will update soon.

> 
>>  }
>>  
>>  /**
>>
> 


-- 
Best regards
Tianyu Lan
