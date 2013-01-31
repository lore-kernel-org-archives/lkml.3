Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754578Ab3AaPXc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:23:32 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:33182 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753359Ab3AaPX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:23:29 -0500
MIME-Version: 1.0
In-Reply-To: <510A56BF.3040804@ti.com>
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
	<510A56BF.3040804@ti.com>
Date: Thu, 31 Jan 2013 20:53:27 +0530
Message-ID: <CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt node.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: kishon <kishon@ti.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        balbi@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,


On Thu, Jan 31, 2013 at 5:04 PM, kishon <kishon@ti.com> wrote:
> Hi,
>

Thanks for your quick help.

>
> On Thursday 31 January 2013 04:50 PM, Vivek Gautam wrote:
>>
>> With device tree support in place for dwc3-core layer,
>> it gets PHY from "synopsis-dwc3" node.
>> Some controllers may not have separate memory maps and interrupts
>> for dwc3 core and platform glue layers. In such case only glue
>> layer's node will exist.
>
>
> Not really. As long as you have dwc3 core as a separate device, you can add
> a node for it.
> Just that the glue should create a device for dwc3 core using
> of_platform_populate.(You can have a look at drivers/usb/dwc3/dwc3-omap.c in
> usb-next)
>

Right, we should be doing this way.

>> Moreover, SoCs having multiple dwc3 controllers will have multiple
>> PHYs, which eventually be added using usb_add_phy_dev(), and not
>> using usb_add_phy(). So each dwc3 controller won't be able to
>> get PHYs by simply calling devm_usb_get_phy() also.
>
> No. We have added usb_get_phy_dev() for that purpose in the case of non-dt.
> I think, instead you can have a patch to use devm_usb_get_phy_dev() here and
> in exynos platform specific code use usb_bind_phy() to bind the phy and
> controller till you change it to dt.
>

We have dt support for dwc3-exynos, in such case we should go ahead with
of_platform_populate(), right ?
But if when i use of_platform_populate() i will not be able to set
dma_mask to dwc3->dev. :-(
And setting it in dwc3_probe() won't be good idea, isn't it ?

>> In such cases, dwc3 should expect PHYs from its parent's node.
>
> NAK.
>
> Thanks
> Kishon
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Thanks & Regards
Vivek
