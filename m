Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab3AaPam (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 10:30:42 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:58501 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886Ab3AaPak (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 10:30:40 -0500
MIME-Version: 1.0
In-Reply-To: <20130131152527.GE4064@arwen.pp.htv.fi>
References: <1359631232-7107-1-git-send-email-gautam.vivek@samsung.com>
	<510A56BF.3040804@ti.com>
	<CAFp+6iFkb=U0CJA=3zmQvd5XfMwbROuRJjXoJG7zvvq4_upzNw@mail.gmail.com>
	<20130131152527.GE4064@arwen.pp.htv.fi>
Date: Thu, 31 Jan 2013 21:00:37 +0530
Message-ID: <CAFp+6iHvKYiF_neANRq5roAEJwhvcaLk7pAd7Dy94Z5XiDkhgA@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: dwc3: Get PHY from platform specific dwc3 dt node.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: kishon <kishon@ti.com>, Vivek Gautam <gautam.vivek@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,


On Thu, Jan 31, 2013 at 8:55 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Thu, Jan 31, 2013 at 08:53:27PM +0530, Vivek Gautam wrote:
>> >> Moreover, SoCs having multiple dwc3 controllers will have multiple
>> >> PHYs, which eventually be added using usb_add_phy_dev(), and not
>> >> using usb_add_phy(). So each dwc3 controller won't be able to
>> >> get PHYs by simply calling devm_usb_get_phy() also.
>> >
>> > No. We have added usb_get_phy_dev() for that purpose in the case of non-dt.
>> > I think, instead you can have a patch to use devm_usb_get_phy_dev() here and
>> > in exynos platform specific code use usb_bind_phy() to bind the phy and
>> > controller till you change it to dt.
>> >
>>
>> We have dt support for dwc3-exynos, in such case we should go ahead with
>> of_platform_populate(), right ?
>> But if when i use of_platform_populate() i will not be able to set
>> dma_mask to dwc3->dev. :-(
>
> do you have a special need for dma_mask because OF already sets it.
>
If i am not wrong of_platform_device_create_pdata() will set
"dev->dev.coherent_dma_mask = DMA_BIT_MASK(32)"
and not dma_mask.
I fact we had some discussion sometime back when we needed the same
for dwc3-exynos in the thread:
[PATCH v2 1/2] USB: dwc3-exynos: Add support for device tree

But couldn't get final node on it.
So suggestions here please. :-)


-- 
Thanks & Regards
Vivek
