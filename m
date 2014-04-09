Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933300AbaDIMYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:24:42 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57496 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932AbaDIMYj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:24:39 -0400
MIME-Version: 1.0
In-Reply-To: <534538F6.2010009@samsung.com>
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
	<534538F6.2010009@samsung.com>
Date: Wed, 9 Apr 2014 17:54:38 +0530
X-Google-Sender-Auth: AwUpkXModHlhhWOtGWdMYAbRR5I
Message-ID: <CAFp+6iHf5Ndt3yNbdAaayXi08-A54Sk8LDTiASm4RTw09GuWvg@mail.gmail.com>
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio on/off
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sylwester,


On Wed, Apr 9, 2014 at 5:41 PM, Sylwester Nawrocki
<s.nawrocki@samsung.com> wrote:
> Hi Vivek,
>
> On 09/04/14 13:54, Vivek Gautam wrote:
>> Adding support to enable/disable VBUS hooked to a gpio
>> to enable vbus supply on the port.
>
> Does the GPIO control a fixed voltage regulator ? If so, shouldn't
> it be modelled by the regulator API instead ?

No, this GPIO controls a 'current limiting power distribution switch',
which gives the output vbus to usb controller.
Should i model this as a fixed regulator ?

>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
> [...]
>> +     /* Get required GPIO for vbus */
>> +     phy_drd->gpio = of_get_named_gpio(dev->of_node,
>> +                                       "samsung,vbus-gpio", 0);
>> +     if (!gpio_is_valid(phy_drd->gpio))
>> +             dev_dbg(dev, "no usbdrd-phy vbus gpio defined\n");
>> +
>> +     if (devm_gpio_request(dev, phy_drd->gpio, "phydrd_vbus_gpio"))
>> +             dev_dbg(dev, "can't request usbdrd-phy vbus gpio %d\n",
>> +                     phy_drd->gpio);
>
> --
> Regards,
> Sylwester
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
