Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159AbaBROhz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:37:55 -0500
Received: from mail-pa0-f45.google.com ([209.85.220.45]:52494 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932134AbaBROhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:37:51 -0500
Message-ID: <5303703A.8060002@linaro.org>
Date: Tue, 18 Feb 2014 22:37:46 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Lan Tianyu <tianyu.lan@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        linaro-acpi@lists.linaro.org
Subject: Re: [PATCH v4 5/5] ACPI: Replace printk with pr_* in tables.c
References: <1392731700-10992-1-git-send-email-hanjun.guo@linaro.org>  <1392731700-10992-6-git-send-email-hanjun.guo@linaro.org> <1392732373.22752.22.camel@joe-AO722>
In-Reply-To: <1392732373.22752.22.camel@joe-AO722>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年02月18日 22:06, Joe Perches wrote:
> On Tue, 2014-02-18 at 21:55 +0800, Hanjun Guo wrote:
>> This patch just do some clean up to replace printk with pr_*,
>> no functional change.
> trivial note:
>
>> diff --git a/drivers/acpi/tables.c b/drivers/acpi/tables.c
> []
>> @@ -55,8 +55,7 @@ void acpi_table_print_madt_entry(struct acpi_subtable_header *header)
>>   		{
>>   			struct acpi_madt_local_apic *p =
>>   			    (struct acpi_madt_local_apic *)header;
>> -			printk(KERN_INFO PREFIX
>> -			       "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
>> +			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
>>   			       p->processor_id, p->id,
>>   			       (p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");
> It'd be nice to realign the additional lines to the open
> parenthesis, here and everywhere else in this patch
>
> 			pr_info(PREFIX "LAPIC (acpi_id[0x%02x] lapic_id[0x%02x] %s)\n",
> 				p->processor_id, p->id,
> 				(p->lapic_flags & ACPI_MADT_ENABLED) ? "enabled" : "disabled");

Thanks for your comments, will update patch 1/5 and 5/5 follow your 
suggestion :)

Hanjun
