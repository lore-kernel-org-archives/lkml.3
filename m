Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325AbaDINJH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 09:09:07 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:16958 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932674AbaDINJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 09:09:01 -0400
X-AuditID: cbfec7f5-b7fc96d000004885-c9-5345466a7301
Message-id: <53454668.8090300@samsung.com>
Date: Wed, 09 Apr 2014 15:08:56 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>
Cc: kishon <kishon@ti.com>, Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Tomasz Figa <t.figa@samsung.com>,
        Kamil Debski <k.debski@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio
 on/off
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
 <534538F6.2010009@samsung.com>
 <CAFp+6iHf5Ndt3yNbdAaayXi08-A54Sk8LDTiASm4RTw09GuWvg@mail.gmail.com>
In-reply-to: <CAFp+6iHf5Ndt3yNbdAaayXi08-A54Sk8LDTiASm4RTw09GuWvg@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrDLMWRmVeSWpSXmKPExsVy+t/xq7pZbq7BBjPeilgcvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbO48LSHzWLT42usFpd3zWGzmHF+H5PFomWtzBbr
	Z7xmceD12D93DbvH5iX1Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsErozb728wFVxh
	q/h6cCN7A+NC1i5GTg4JAROJxldPWSBsMYkL99azdTFycQgJLGWUOHBzBiOE84lRYub5JiaQ
	Kl4BLYmzD+aAdbMIqErMe/KJGcRmEzCU6D3axwhiiwpESNxrPMwKUS8o8WPyPbANIgLaEtvn
	TmIFGcossI9FondhO1hCWCBY4uehR1DbNjBKfHrznR0kwQmUOH3gOtgkZgEdif2t09ggbHmJ
	zWveMk9gFJiFZMksJGWzkJQtYGRexSiaWppcUJyUnmukV5yYW1yal66XnJ+7iRESI193MC49
	ZnWIUYCDUYmHV8HSJViINbGsuDL3EKMEB7OSCG+bgWuwEG9KYmVValF+fFFpTmrxIUYmDk6p
	BsaU2A8q8q+dptl/zb0zP+TyjW8yeeeuqPFEK/HKf9iiXhsVN9dZKzF77ZFjYYYf1pXIzc4S
	b5SaGXWHITnNrS71oWNw+FKmY3u97h4NrMp6etxrz6ZnV2dsFTgSXOBSeOkUS+Zs6Q2fevV2
	1TlOnX337adT4mzT1uV8kNKJuzB/zuO85Qu3O6UrsRRnJBpqMRcVJwIAAG82228CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/14 14:24, Vivek Gautam wrote:
> On Wed, Apr 9, 2014 at 5:41 PM, Sylwester Nawrocki
> <s.nawrocki@samsung.com> wrote:
>> > On 09/04/14 13:54, Vivek Gautam wrote:
>>> >> Adding support to enable/disable VBUS hooked to a gpio
>>> >> to enable vbus supply on the port.
>> >
>> > Does the GPIO control a fixed voltage regulator ? If so, shouldn't
>> > it be modelled by the regulator API instead ?
>
> No, this GPIO controls a 'current limiting power distribution switch',
> which gives the output vbus to usb controller.
> Should i model this as a fixed regulator ?

OK, it's just a power switch then. I suspect using the regulator API
would be more universal, as such a GPIO is somewhat a board design
detail. I'm not going to object to your patch, just might be better
to use the gpiod API instead.

-- 
Regards,
Sylwester
