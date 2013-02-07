Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759059Ab3BGQ4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:56:16 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:36915 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756622Ab3BGQ4O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:56:14 -0500
Message-ID: <5113DCAC.6080003@wwwdotorg.org>
Date: Thu, 07 Feb 2013 09:56:12 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: kishon <kishon@ti.com>
CC: Venu Byravarasu <vbyravarasu@nvidia.com>, balbi@ti.com,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH v3] usb: phy: moving all PHY API definitions to usb/phy
 directory
References: <1360236751-23183-1-git-send-email-vbyravarasu@nvidia.com> <5113AE42.8090401@ti.com>
In-Reply-To: <5113AE42.8090401@ti.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2013 06:38 AM, kishon wrote:
> On Thursday 07 February 2013 05:02 PM, Venu Byravarasu wrote:
>> As drivers/usb/otg/otg.c contains most of the PHY related APIs which
>> are not OTG specific, moving them to more logical place under
>> drivers/usb/phy.

>> diff --git a/drivers/usb/phy/Makefile b/drivers/usb/phy/Makefile
>> index b13faa1..886be13 100644
>> --- a/drivers/usb/phy/Makefile
>> +++ b/drivers/usb/phy/Makefile
>> @@ -4,6 +4,7 @@
>>
>>   ccflags-$(CONFIG_USB_DEBUG) := -DDEBUG
>>
>> +obj-$(CONFIG_USB_COMMON)            += phy.o
> 
> I think we should have a separate config for PHYs. There might be
> controllers which dont need separate PHY. But we can have that as a
> separate patch later since we might want to change the Kconfig of other
> UDC drivers.

>> +/*
>> + * phy.c -- USB PHY utility code
>> + *
>> + * Copyright (C) 2004 Texas Instruments
> 
> You can update this to 2013.

I'm not sure if anyone other that TI can do that?

>> +EXPORT_SYMBOL_GPL(usb_bind_phy);
>> +
>> +
>
> Unnecessary spaces here.

Thanks for the review. It was very difficult to find you review comments
since you quoted the entire patch rather than just the few pieces you
were commenting on...

> You might want to do this patch after applying *[PATCH] usb: otg: use
> try_module_get in all usb_get_phy functions and add missing module_put*
> by Marc.

Venu, please make sure you include the changes in that patch in your
Tegra USB/PHY driver rework too, before you post it upstream.
