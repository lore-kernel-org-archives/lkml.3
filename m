Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758915Ab3EGInP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 04:43:15 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:59687 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758500Ab3EGInL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 04:43:11 -0400
Message-ID: <5188B8A9.9040709@ti.com>
Date: Tue, 7 May 2013 13:47:45 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>
CC: <myungjoo.ham@samsung.com>, <balbi@ti.com>, <ldewangan@nvidia.com>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>, <gg@slimlogic.co.uk>,
        <ruchika@ti.com>, <tony@atomide.com>, <sameo@linux.intel.com>,
        <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1367846225-15685-1-git-send-email-kishon@ti.com> <51889AD9.9030902@samsung.com> <51889E55.8090306@ti.com> <5188A5EC.8020705@samsung.com> <5188A7BE.4080509@samsung.com>
In-Reply-To: <5188A7BE.4080509@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 May 2013 12:35 PM, Chanwoo Choi wrote:
> On 05/07/2013 03:57 PM, Chanwoo Choi wrote:
>> diff --git a/include/linux/extcon/extcon_palmas.h b/include/linux/extcon/extcon_palmas.h
>> new file mode 100644
>> index 0000000..a5119c9
>> --- /dev/null
>> +++ b/include/linux/extcon/extcon_palmas.h
>> @@ -0,0 +1,26 @@
>> +/*
>> + * extcon_palmas.h - palmas extcon driver to detect VBUS or ID events
>> + *
>> + * Copyright (C) 2013 Texas Instruments Incorporated - http://www.ti.com
>> + * This program is free software; you can redistribute it and/or modify
>> + * it under the terms of the GNU General Public License as published by
>> + * the Free Software Foundation; either version 2 of the License, or
>> + * (at your option) any later version.
>> + *
>> + * Author: Kishon Vijay Abraham I <kishon@ti.com>
>> + *
>> + * This program is distributed in the hope that it will be useful,
>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>> + * GNU General Public License for more details.
>> + *
>> + */
>> +
>> +#ifndef __EXTCON_PALMAS_H__
>> +#define __EXTCON_PALMAS_H__
>> +
>> +#define    PALMAS_USB_STATE_DISCONNECT    0x0
>> +#define    PALMAS_USB_STATE_VBUS        BIT(0)
>> +#define    PALMAS_USB_STATE_ID        BIT(1)
>> +
>>>> The defined variable in extcon_palmas.h is used only on extcon-palmas.c.
>>>> So, I would like to move definition from extcon_palmas.h to extcon-palmas.c
>>>> and remove extcon_palmas.h header file.
>>> Actually it has to be used in dwc3-omap.c (that was in a different patch).
>>>
>> Should detect the state of USB/USB-HOST on dwc3-omap driver?
>>
>> If yes, dwc3-omap driver can immediately detect the changed state of USB/USB-HOST
>> by using excon_register_interest() function which is defined in extcon-class.c
>>
>> I explain simple usage of extcon_register_interest()
>> to receive newly state of USB cable on dwc3-omap driver.
>> -----------
>>      struct extcon_specific_cable_nb extcon_notifier
>>      struct notifier_block extcon_notifier;
>>
>>       /* ... */
>>
>>      extcon_notifier.notifier_call = omap_extcon_notifier;
>>      ret = extcon_register_interest(&extcon_dev, "USB", &extcon_notifier);
>      Fix usage of extcon_register_interest() as following:
>
>      ret = extcon_register_interest(&extcon_dev, NULL, "USB", &extcon_notifier); or
>      ret = extcon_register_interest(&extcon_dev, "palmas-usb", "USB", &extcon_notifier);

By this we have to define 2 notifiers (one for USB and the other for 
USB-HOST). I thought of having a single notifier and handling it using 
states. It was something like this http://pastebin.com/Nv7q9swz.

Thanks
Kishon
