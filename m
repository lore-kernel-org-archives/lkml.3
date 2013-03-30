Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab3C3HQA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 03:16:00 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:27098 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab3C3HP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 03:15:59 -0400
Message-ID: <51569129.8020106@atmel.com>
Date: Sat, 30 Mar 2013 08:15:53 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        <linux-usb@vger.kernel.org>,
        Manjunath Goudar <manjunath.goudar@linaro.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Greg KH <greg@kroah.com>, Andrew Victor <linux@maxim.org.za>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>
Subject: Re: [PATCH v3 5/7] USB: EHCI: make ehci-atmel a separate driver
References: <Pine.LNX.4.44L0.1303291600080.1467-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303291600080.1467-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2013 09:02 PM, Alan Stern :
> On Thu, 28 Mar 2013, Arnd Bergmann wrote:
> 
>> From: Manjunath Goudar <manjunath.goudar@linaro.org>
>>
>> Separate the Atmel host controller driver from ehci-hcd host code
>> so that it can be built as a separate driver module.
>> This work is part of enabling multi-platform kernels on ARM;
>> however, note that other changes are still needed before Atmel can be
>> booted with a multi-platform kernel. This is currently planned for
>> Linux-3.11.
>>
>> With the infrastructure added by Alan Stern in patch 3e0232039
>> "USB: EHCI: prepare to make ehci-hcd a library module", we can
>> avoid this problem by turning a bus glue into a separate
>> module, as we do here for the Atmel bus glue.
> 
> Generally okay.
> 
>> diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
>> index 01c1acb..8c564aa 100644
>> --- a/drivers/usb/host/ehci-atmel.c
>> +++ b/drivers/usb/host/ehci-atmel.c


I missed the patch itself but I reviewed it on the mailing-list archive.
So, here is my:

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks a lot for having taking care of this driver.

Best regards,


>> @@ -15,6 +15,19 @@
>>  #include <linux/platform_device.h>
>>  #include <linux/of.h>
>>  #include <linux/of_platform.h>
>> +#include <linux/kernel.h>
>> +#include <linux/module.h>
>> +#include <linux/usb.h>
>> +#include <linux/usb/hcd.h>
>> +#include <linux/io.h>
>> +#include <linux/dma-mapping.h>
> 
> While not absolutely necessary, it would be nice to have the #include 
> files in alphabetical order.
> 
>> +
>> +#include "ehci.h"
>> +
>> +#define DRIVER_DESC "EHCI atmel driver"
> 
> "atmel" should have a capital 'A'.
> 
> Alan Stern
> 
> 
> 


-- 
Nicolas Ferre
