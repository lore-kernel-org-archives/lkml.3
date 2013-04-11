Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936222Ab3DKOoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 10:44:08 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:54428 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3DKOoG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 10:44:06 -0400
Message-ID: <5166CC30.4060507@ti.com>
Date: Thu, 11 Apr 2013 17:44:00 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, <balbi@ti.com>
CC: Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-omap: Select USB_PHY
References: <5166856C.3080906@ti.com> <20130411100435.GB14394@arwen.pp.htv.fi> <516695A4.2050804@ti.com> <20130411105557.GE14394@arwen.pp.htv.fi> <5166AFD2.4070108@ti.com> <5166B450.1000404@ahsoftware.de>
In-Reply-To: <5166B450.1000404@ahsoftware.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On 04/11/2013 04:02 PM, Alexander Holler wrote:
> Am 11.04.2013 14:42, schrieb Roger Quadros:
>> On 04/11/2013 01:55 PM, Felipe Balbi wrote:
> 
>>> I would avoid 'select' completely and just update omap2plus_defconfig
>>> adding those two as modules.

Setting USB_PHY as a module gives rise to these problems

arch/arm/mach-omap2/built-in.o: In function `usbhs_init_phys':
/work/linux-2.6/arch/arm/mach-omap2/usb-host.c:652: undefined reference to `usb_bind_phy'
arch/arm/mach-omap2/built-in.o: In function `omap_2430sdp_init':
/work/linux-2.6/arch/arm/mach-omap2/board-2430sdp.c:236: undefined reference to `usb_bind_phy'
arch/arm/mach-omap2/built-in.o: In function `omap3_beagle_init':
/work/linux-2.6/arch/arm/mach-omap2/board-omap3beagle.c:554: undefined reference to `usb_bind_phy'
arch/arm/mach-omap2/built-in.o: In function `devkit8000_init':
/work/linux-2.6/arch/arm/mach-omap2/board-devkit8000.c:596: undefined reference to `usb_bind_phy'
arch/arm/mach-omap2/built-in.o: In function `omap_ldp_init':
/work/linux-2.6/arch/arm/mach-omap2/board-ldp.c:379: undefined reference to `usb_bind_phy'

So USB_PHY shouldn't be tristate IMO or at least the platform registration stuff
as the usb_bind_phy() part is used by platform code.

>>>
>>
>> OK, makes sense. I will update the patch to remove "select NOP_USB_XCEIV".
> 
> Sorry, but this just will end up with many users having broken configs
> because of disabled stuff they don't know why they have to enable them.
> And thus with a never ending stream of questions and thus with a needed
> FAQ entry.
> 

Alexander,

I agree with you that it can get difficult with users. But it is best for
users do not disable anything they are not familiar with.

As the USB_PHY option doesn't depend on anything, it is safe to select it
from USB_EHCI_HCD_OMAP.

However, the PHY drivers themselves must be selected from the board configs.

cheers,
-roger
