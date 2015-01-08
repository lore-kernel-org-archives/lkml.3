Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753625AbbAHHuY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 02:50:24 -0500
Received: from mail-pa0-f50.google.com ([209.85.220.50]:62742 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753316AbbAHHuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 02:50:21 -0500
Message-ID: <54AE36AF.3070603@linaro.org>
Date: Thu, 08 Jan 2015 15:50:07 +0800
From: Hanjun Guo <hanjun.guo@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Feng Kan <fkan@apm.com>, patches <patches@apm.com>,
        linux-ide@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Mark Salter <msalter@redhat.com>, tj@kernel.org, hdegoede@redhat.com
Subject: Re: [PATCH] sata: xgene: add ACPI support for APM X-Gene SATA ports
References: <1418337070-17644-1-git-send-email-fkan@apm.com> <CAL85gmAHLk9XCbr-1+USmOKxd5O7iCxWX0vqSRf74Brn2pzESg@mail.gmail.com>
In-Reply-To: <CAL85gmAHLk9XCbr-1+USmOKxd5O7iCxWX0vqSRf74Brn2pzESg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng Kan,

I have some comments below.

On 2015年01月08日 01:32, Feng Kan wrote:
> Just want to ping this again.
>
> Happy new year
>
> On Thu, Dec 11, 2014 at 2:31 PM, Feng Kan <fkan@apm.com> wrote:
>> This adds ACPI support for the APM X-Gene SATA ports. When the system
>> boots using ACPI table, the SATA ports are able to configure using the
>> values supplied by the ACPI table rather than the DTS.
>>
>> Signed-off-by: Feng Kan <fkan@apm.com>
>> ---
>>   drivers/ata/ahci_xgene.c | 10 ++++++++++
>>   1 file changed, 10 insertions(+)
>>
>> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
>> index d0c851a..4951392 100644
>> --- a/drivers/ata/ahci_xgene.c
>> +++ b/drivers/ata/ahci_xgene.c
>> @@ -22,6 +22,7 @@
>>    * NOTE: PM support is not currently available.
>>    *
>>    */
>> +#include <linux/acpi.h>
>>   #include <linux/module.h>
>>   #include <linux/platform_device.h>
>>   #include <linux/ahci_platform.h>
>> @@ -521,6 +522,14 @@ disable_resources:
>>          return rc;
>>   }
>>
>> +#ifdef CONFIG_ACPI
>> +static const struct acpi_device_id xgene_ahci_acpi_match[] = {
>> +       { "APMC0D0D", },

When I was going through the PNP and ACPI ID list in
http://www.uefi.org/PNP_ACPI_Registry, I found that
there is no "APMC" for ACPI ID, I only found that there is
a PNP ID "APM" for Applied Memory Tech company, are
you using PNP ID for this one?

if not, I think you can send a request to UEFI and
request a new ACPI ID of "APMC" for Applied Micro, and then
submit the patch again.

How to send a request to register the ACPI ID, you can
refer to:
http://www.uefi.org/PNP_ACPI_Registry

Thanks
Hanjun
