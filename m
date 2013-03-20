Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752260Ab3CTX51 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 19:57:27 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50904 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab3CTX5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 19:57:24 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <514A4CCD.6000608@jp.fujitsu.com>
Date: Thu, 21 Mar 2013 08:57:01 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Toshi Kani <toshi.kani@hp.com>
CC: <rjw@sisk.pl>, <linux-acpi@vger.kernel.org>, <tangchen@cn.fujitsu.com>,
        <wency@cn.fujitsu.com>, <laijs@cn.fujitsu.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove acpi_memory_info->failed bit
References: <514022BF.3080303@jp.fujitsu.com>  <1363186213.12845.174.camel@misato.fc.hp.com>  <514679BC.5020700@jp.fujitsu.com> <1363705437.11659.5.camel@misato.fc.hp.com>
In-Reply-To: <1363705437.11659.5.camel@misato.fc.hp.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Toshi,

2013/03/20 0:03, Toshi Kani wrote:
> On Mon, 2013-03-18 at 11:19 +0900, Yasuaki Ishimatsu wrote:
>> Hi Toshi,
>>
>> Sorry for the late reply
>>
>> 2013/03/13 23:50, Toshi Kani wrote:
>>> On Wed, 2013-03-13 at 15:54 +0900, Yasuaki Ishimatsu wrote:
>>>> At http://marc.info/?l=linux-acpi&m=135769405622667&w=2 thread,
>>>> Toshi Kani mentioned as follows:
>>>>
>>>> "I have a question about the change you made in commit 65479472 in
>>>> acpi_memhotplug.c.  This change seems to require that
>>>> acpi_memory_enable_device() calls add_memory() to add all memory ranges
>>>> represented by memory device objects at boot-time, and keep the results
>>>> be used for hot-remove.
>>>>
>>>> If I understand it right, this add_memory() call fails with EEXIST at
>>>> boot-time since all memory ranges should have been added from EFI memory
>>>> table (or e820) already.  This results all memory ranges be marked as !
>>>> enabled & !failed.  I think this means that we cannot hot-delete any
>>>> memory ranges presented at boot-time since acpi_memory_remove_memory()
>>>> only calls remove_memory() when the enabled flag is set.  Is that
>>>> correct?"
>>>>
>>>> Above mention is correct. Thus even if memory device supports hotplug,
>>>> memory presented at boot-time cannot be hot removed since the memory
>>>> device's acpi_memory_info->enabled is always 0.
>>>>
>>>> This patch changes to set 1 to "acpi_memory_info->enabled" of memory
>>>> device presented at boot-time for hot removing the memory device.
>>>>
>>>> Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>>>>
>>>> ---
>>>>    drivers/acpi/acpi_memhotplug.c |    4 ++--
>>>>    1 files changed, 2 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/drivers/acpi/acpi_memhotplug.c b/drivers/acpi/acpi_memhotplug.c
>>>> index da1f82b..88fd46a 100644
>>>> --- a/drivers/acpi/acpi_memhotplug.c
>>>> +++ b/drivers/acpi/acpi_memhotplug.c
>>>> @@ -254,8 +254,8 @@ static int acpi_memory_enable_device(struct acpi_memory_device *mem_device)
>>>>    			continue;
>>>>    		}
>>>>
>>>> -		if (!result)
>>>> -			info->enabled = 1;
>>>> +		info->enabled = 1;
>>>
>>> Do we still need to keep the enable bit?  I think !failed means enabled
>>> with this change.
>>
>> For controlling memory hotplug, we need either failed bit or enabled bit.
>> So I want to remove failed bit as follows:
>>
>> ---
>>
>> acpi_memory_info has enabled bit and failed bit for controlling memory
>> hotplug. But we don't need to keep both bits.
>>
>> The patch removes acpi_memory_info->failed bit.
>
> Thanks for the update.  Which branch does this patch apply to?  I tried
> several, but could not apply.

These patches are based on linux-3.9-rc3.
O.K. I'll make them based on linux-pm.git/bleeding-edge.

Thanks,
Yasuaki Ishimatsu

> -Toshi
>
>


