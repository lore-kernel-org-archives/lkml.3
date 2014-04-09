Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933190AbaDIMLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 08:11:42 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:11383 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932542AbaDIMLi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 08:11:38 -0400
X-AuditID: cbfec7f4-b7f796d000005a13-f0-534538f8fc9c
Message-id: <534538F6.2010009@samsung.com>
Date: Wed, 09 Apr 2014 14:11:34 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Vivek Gautam <gautam.vivek@samsung.com>, kishon@ti.com
Cc: linux-usb@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, gregkh@linuxfoundation.org, balbi@ti.com,
        kgene.kim@samsung.com, t.figa@samsung.com, k.debski@samsung.com,
        jg1.han@samsung.com
Subject: Re: [PATCH] phy: exynos5-usbdrd: Add facility to toggle vbus gpio
 on/off
References: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
In-reply-to: <1397044485-26483-1-git-send-email-gautam.vivek@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrFLMWRmVeSWpSXmKPExsVy+t/xa7o/LFyDDTY0i1scvF9vMf/IOVaL
	tisH2S2aF69ns7i88BKrxY/XF9gsehdcZbO48LSHzWLT42usFpd3zWGzmHF+H5PFomWtzBbr
	Z7xmceD12D93DbvH5iX1Hn1bVjF6HL+xncnj8ya5ANYoLpuU1JzMstQifbsErozzS3exFDxj
	rdi6X7yB8RpLFyMnh4SAicTX24/ZIWwxiQv31rN1MXJxCAksZZTYsfkNM4TziVFiQ+NCJpAq
	XgEtid5bTWA2i4CqxJn/ixhBbDYBQ4neo31gtqhAhMS9xsOsEPWCEj8m3wPbJiJgJTHp/1yw
	ocwCK5gkHh5YxgaSEBYIlvh56BFYs5CAh8TSacfBTuIU8JTo+nQDrIZZQEdif+s0KFteYvOa
	t8wTGAVmIdkxC0nZLCRlCxiZVzGKppYmFxQnpeca6hUn5haX5qXrJefnbmKExMeXHYyLj1kd
	YhTgYFTi4VWwdAkWYk0sK67MPcQowcGsJMLbZuAaLMSbklhZlVqUH19UmpNafIiRiYNTqoFx
	ko/B6pcnZd+JNKifVnZasbtL0feNac88tf6XCZP5Pof8d7x3REKkJDWHw98jz9PvUebRM7wR
	D5TbXff+7v+/oHpnqgef2EcdqdXXpPPO/HjifIT12an932eqR7UyrV/8pm9P8v4D9yUVui+0
	det5fT7nWZ3w33khx+foGIuvdmJrv1pdD9RTYinOSDTUYi4qTgQAAQeVym0CAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Vivek,

On 09/04/14 13:54, Vivek Gautam wrote:
> Adding support to enable/disable VBUS hooked to a gpio
> to enable vbus supply on the port.

Does the GPIO control a fixed voltage regulator ? If so, shouldn't
it be modelled by the regulator API instead ?

> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
[...]
> +	/* Get required GPIO for vbus */
> +	phy_drd->gpio = of_get_named_gpio(dev->of_node,
> +					  "samsung,vbus-gpio", 0);
> +	if (!gpio_is_valid(phy_drd->gpio))
> +		dev_dbg(dev, "no usbdrd-phy vbus gpio defined\n");
> +
> +	if (devm_gpio_request(dev, phy_drd->gpio, "phydrd_vbus_gpio"))
> +		dev_dbg(dev, "can't request usbdrd-phy vbus gpio %d\n",
> +			phy_drd->gpio);

--
Regards,
Sylwester
