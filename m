Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab3IKO0Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:26:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:57911 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754442Ab3IKO0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:26:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,884,1371106800"; 
   d="scan'208";a="293555338"
Message-ID: <52307D9D.3070801@intel.com>
Date: Wed, 11 Sep 2013 10:26:37 -0400
From: Lan Tianyu <tianyu.lan@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130612 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: lenb@kernel.org, yinghai@kernel.org, bhelgaas@google.com,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 2/4] ACPI/Resource: Add address translation support
References: <1378477486-8758-1-git-send-email-tianyu.lan@intel.com> <1378477486-8758-3-git-send-email-tianyu.lan@intel.com> <12539726.iB4h1i35EF@vostro.rjw.lan> <522D3002.5050304@intel.com>
In-Reply-To: <522D3002.5050304@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/08/2013 10:18 PM, Lan Tianyu wrote:
> On 2013年09月07日 08:15, Rafael J. Wysocki wrote:
>> On Friday, September 06, 2013 10:24:44 AM Lan Tianyu wrote:
>>> According ACPI 5.0 spec Section 19.1.8
>>> "For bridges, translate addresses across the bridge, this is the
>>> offset that must be added to the address on the secondary side
>>> to obtain the address on the primary side. Non-bridge devices
>>> must list 0."
>>
>> Can you please have a look into the previous versions of the spec and double
>> check that this change won't confuse systems that implement them?
>>
>
> Hi Rafael:
>           I check all versions. This part has existed and not been
> changed since ACPI 1.0.
>

Hi Rafael:
	Do you have other comments on this?


>> Otherwise it looks OK to me.
>>
>> Thanks,
>> Rafael
>>
>>
>>> This patch is to add address translation offset to the start/end
>>> of struct resource in the acpi_dev_resource_address_space().
>>> Further more, non-bridge device's translation_offset should 0.
>>> So this change will affect other devices.
>>>
>>>
>>> Signed-off-by: Lan Tianyu <tianyu.lan@intel.com>
>>> ---
>>>   drivers/acpi/resource.c | 4 ++--
>>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
>>> index 929f416..84bc3db 100644
>>> --- a/drivers/acpi/resource.c
>>> +++ b/drivers/acpi/resource.c
>>> @@ -192,8 +192,8 @@ bool acpi_dev_resource_address_space(struct acpi_resource *ares,
>>>   	if (ACPI_FAILURE(status))
>>>   		return true;
>>>
>>> -	res->start = addr.minimum;
>>> -	res->end = addr.maximum;
>>> +	res->start = addr.minimum + addr.translation_offset;
>>> +	res->end = addr.maximum + addr.translation_offset;
>>>   	window = addr.producer_consumer == ACPI_PRODUCER;
>>>
>>>   	switch(addr.resource_type) {
>>>
>
>

