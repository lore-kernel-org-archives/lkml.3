Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbaJVHfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 03:35:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:26980 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751105AbaJVHfF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 03:35:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,767,1406617200"; 
   d="scan'208";a="618365535"
Message-ID: <54475DB4.5000005@intel.com>
Date: Wed, 22 Oct 2014 10:33:08 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki 
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
CC: Felipe Balbi <balbi@ti.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        linux-usb@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [resend PATCH 1/3] ACPI / platform: provide default DMA mask
References: <1411545639-18741-1-git-send-email-heikki.krogerus@linux.intel.com> <2261149.pJ2DW810R9@vostro.rjw.lan> <54465141.1080408@intel.com> <1885056.A9IZAntn96@vostro.rjw.lan> <54465C0E.50801@intel.com>
In-Reply-To: <54465C0E.50801@intel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/10/14 16:13, Adrian Hunter wrote:
> On 21/10/14 16:08, Rafael J. Wysocki wrote:
>> On Tuesday, October 21, 2014 03:27:45 PM Adrian Hunter wrote:
>>> On 24/09/14 16:49, Rafael J. Wysocki wrote:
>>>> On Wednesday, September 24, 2014 11:00:37 AM Heikki Krogerus wrote:
>>>>> Most devices are configured for 32-bit DMA addresses.
>>>>> Setting the mask to 32-bit here removes the need for the
>>>>> drivers to do it separately.
>>>>>
>>>>> Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
>>>>> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
>>>>
>>>> ACK
>>>
>>> Hi
>>>
>>> I need this for another driver.  Did this patch go anywhere?
>>
>> It's not in 3.18-rc1 as far as I can say.
>>
>>> Note Heikki is away at the moment.
>>
>> That's OK.  I guess I can queue up this one for you.
>>
>> When do you need this to get into the Linus' tree?
> 
> My patches are aiming for 3.19

Actually it would be easier for me if Heikki's patch is already in
3.18, but all I need to know is when it will hit?

> 
>>
>>
>>>>> ---
>>>>>  drivers/acpi/acpi_platform.c | 2 ++
>>>>>  1 file changed, 2 insertions(+)
>>>>>
>>>>> diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
>>>>> index 2bf9082..8d099e6 100644
>>>>> --- a/drivers/acpi/acpi_platform.c
>>>>> +++ b/drivers/acpi/acpi_platform.c
>>>>> @@ -16,6 +16,7 @@
>>>>>  #include <linux/err.h>
>>>>>  #include <linux/kernel.h>
>>>>>  #include <linux/module.h>
>>>>> +#include <linux/dma-mapping.h>
>>>>>  #include <linux/platform_device.h>
>>>>>  
>>>>>  #include "internal.h"
>>>>> @@ -102,6 +103,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
>>>>>  	pdevinfo.res = resources;
>>>>>  	pdevinfo.num_res = count;
>>>>>  	pdevinfo.acpi_node.companion = adev;
>>>>> +	pdevinfo.dma_mask = DMA_BIT_MASK(32);
>>>>>  	pdev = platform_device_register_full(&pdevinfo);
>>>>>  	if (IS_ERR(pdev))
>>>>>  		dev_err(&adev->dev, "platform device creation failed: %ld\n",
>>>>>
>>>>
>>>
>>
> 
> 
> 

