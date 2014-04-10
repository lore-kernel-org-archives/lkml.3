Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030328AbaDJLHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 07:07:09 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:61028 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030252AbaDJLHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 07:07:06 -0400
MIME-Version: 1.0
In-Reply-To: <53453F2E.40606@samsung.com>
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
	<534538F6.2010009@samsung.com>
	<CAFp+6iHf5Ndt3yNbdAaayXi08-A54Sk8LDTiASm4RTw09GuWvg@mail.gmail.com>
	<53453F2E.40606@samsung.com>
Date: Thu, 10 Apr 2014 16:37:04 +0530
X-Google-Sender-Auth: MAadPyIEcPihvcPVK145LoSwOIQ
Message-ID: <CAFp+6iEktKhksj8-SaDr3Ep7iFf+cyp4-xNmw9DrmmiV5J6wyA@mail.gmail.com>
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio on/off
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <t.figa@samsung.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>, kishon <kishon@ti.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Apr 9, 2014 at 6:08 PM, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi,
>
>
> On 09.04.2014 14:24, Vivek Gautam wrote:
>>
>> Hi Sylwester,
>>
>>
>> On Wed, Apr 9, 2014 at 5:41 PM, Sylwester Nawrocki
>> <s.nawrocki@samsung.com> wrote:
>>>
>>> Hi Vivek,
>>>
>>> On 09/04/14 13:54, Vivek Gautam wrote:
>>>>
>>>> Adding support to enable/disable VBUS hooked to a gpio
>>>> to enable vbus supply on the port.
>>>
>>>
>>> Does the GPIO control a fixed voltage regulator ? If so, shouldn't
>>> it be modelled by the regulator API instead ?
>>
>>
>> No, this GPIO controls a 'current limiting power distribution switch',
>> which gives the output vbus to usb controller.
>> Should i model this as a fixed regulator ?
>
>
> If I understand this correctly, this is just a switch that lets you control
> whether vbus is provided to the USB connector or not. If so, this doesn't
> look like an Exynos-specific thing at all and should rather be modeled on
> higher level.

You are right. The Vbus to the USB connector is given through this a
switch which current limiting capabilities.
This switch just provides the 5V at its input to its output based on
the state of Enable pin
(which is the GPIO we are talking in this patch).

So can you please suggest on how this should be handled ?

>
> Best regards,
> Tomasz
> --
> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
