Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753798Ab3GIMEQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jul 2013 08:04:16 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34960 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752553Ab3GIMEO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jul 2013 08:04:14 -0400
Message-ID: <51DBFC33.3040705@ti.com>
Date: Tue, 9 Jul 2013 15:04:03 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>, <arnd@arndb.de>,
        <adrienverge@gmail.com>, <kishon@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Pavankumar Kondeti <pkondeti@codeaurora.org>,
        Roland Stigge <stigge@antcom.de>
Subject: Re: [PATCH v3 1/2] USB: PHY: Make PHY driver selection possible by
 controller drivers
References: <1371203502-29624-1-git-send-email-rogerq@ti.com> <1371203502-29624-2-git-send-email-rogerq@ti.com> <20130709112948.GJ5552@arwen.pp.htv.fi> <51DBFB8A.6000908@ti.com> <20130709120258.GO5552@arwen.pp.htv.fi>
In-Reply-To: <20130709120258.GO5552@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2013 03:02 PM, Felipe Balbi wrote:
> On Tue, Jul 09, 2013 at 03:01:14PM +0300, Roger Quadros wrote:
>> On 07/09/2013 02:29 PM, Felipe Balbi wrote:
>>> On Fri, Jun 14, 2013 at 12:51:41PM +0300, Roger Quadros wrote:
>>>> Convert PHY Drivers from menuconfig to menu so that the PHY drivers
>>>> can be explicitely selected by the controller drivers.
>>>>
>>>> USB_PHY is no longer a user visible option. It is upto to the PHY
>>>> drivers to select it if needed. This patch does so for the existing
>>>> PHY drivers that use the USB_PHY library.
>>>>
>>>> Doing so moves the USB_PHY and PHY driver selection problem from the
>>>> end user to the PHY and controller driver developer.
>>>>
>>>> e.g.
>>>>
>>>> Earlier, a controller driver (e.g. EHCI_OMAP) that needs to select
>>>> a PHY driver (e.g. NOP_PHY) couldn't do so because the PHY driver
>>>> depended on USB_PHY. Making the controller driver depend on USB_PHY
>>>> has a negative effect i.e. it becomes invisible to the user till
>>>> USB_PHY is enabled. Most end users will not familiar with this.
>>>>
>>>> With this patch, the end user just needs to select the controller driver
>>>> needed for his/her platform without worrying about which PHY driver to
>>>> select.
>>>>
>>>> Also update USB_EHCI_MSM, USB_LPC32XX and USB_OMAP to not depend
>>>> on USB_PHY any more. They can safely select the necessary PHY drivers.
>>>>
>>>> CC: Pavankumar Kondeti <pkondeti@codeaurora.org>
>>>> CC: Roland Stigge <stigge@antcom.de>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>> [USB_LPC32XX part] Acked-by: Roland Stigge <stigge@antcom.de>
>>>>
>>>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>>>
>>> There is one problem (?) with this: phy-core.ko will never be a module.
>>> If that's not a problem for anyone, I guess this is safe to apply. I'll
>>> wait a little longer until merge window closes to give people some extra
>>> time to shout.
>>>
>>
>> Is phy-core already meant to be loaded as a module already?
>>
>> At least with the old phy.c I was getting the following build errors if it was built as
>> a module
>>
>> arch/arm/mach-omap2/built-in.o: In function `usbhs_init_phys':
>> /work/linux-2.6/arch/arm/mach-omap2/usb-host.c:652: undefined reference to `usb_bind_phy'
>> arch/arm/mach-omap2/built-in.o: In function `omap_2430sdp_init':
>> /work/linux-2.6/arch/arm/mach-omap2/board-2430sdp.c:236: undefined reference to `usb_bind_phy'
>> arch/arm/mach-omap2/built-in.o: In function `omap3_beagle_init':
>> /work/linux-2.6/arch/arm/mach-omap2/board-omap3beagle.c:554: undefined reference to `usb_bind_phy'
>> arch/arm/mach-omap2/built-in.o: In function `devkit8000_init':
>> /work/linux-2.6/arch/arm/mach-omap2/board-devkit8000.c:596: undefined reference to `usb_bind_phy'
>> arch/arm/mach-omap2/built-in.o: In function `omap_ldp_init':
>> /work/linux-2.6/arch/arm/mach-omap2/board-ldp.c:379: undefined reference to `usb_bind_phy'
>>
>> If we are sure it can be built as a module then we could just change "config USB_PHY" to tristate
>> instead of bool.
> 
> good point, board-files are using some of our symbols. Then we can apply
> your patches. I'll wait a bit longer, though.
> 
Thanks :) and no problem with the wait.

cheers,
-roger
