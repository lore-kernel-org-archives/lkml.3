Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754668Ab3ESPWg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 May 2013 11:22:36 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:33715 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753068Ab3ESPWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 May 2013 11:22:35 -0400
X-RZG-AUTH: :P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBBWYxhJvJPtnXtogBWn6YvUkYzDKvBT07wx/0LJ4BNA==
X-RZG-CLASS-ID: mo00
Date: Sun, 19 May 2013 17:22:30 +0200
From: Michael Braun <michael.braun@fem.tu-ilmenau.de>
To: Shengzhou Liu <Shengzhou.Liu@freescale.com>
Cc: projekt-wlan@fem.tu-ilmenau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        linux-kernel@vger.kernel.org
Subject: Re: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
 Freescale P1020
Message-ID: <20130519152230.GA2938@dynamic.fami-braun.de>
References: <20130417100809.GA8855@dynamic.fami-braun.de>
 <3F453DDFF675A64A89321A1F3528102199A20F@039-SN1MPN1-004.039d.mgd.msft.net>
 <751900163975fc8d055bd2414c76d59b@fami-braun.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <751900163975fc8d055bd2414c76d59b@fami-braun.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've got hardware here to test with, so if there any changes to test, I'm willing to support.
Meanwhile, might it be a good idea to make that check optional - i.e. add a module parameter or something like this around it?

Regards,
 M. Braun

On Thu, Apr 18, 2013 at 05:13:39PM +0200, michael-dev wrote:
> Hi,
> 
> thanks for the quick reply.
> 
> >Please review the patch http://patchwork.ozlabs.org/patch/237201/
> I applied it, but it does not make any difference on my platform.
> 
> Regards,
>  M. Braun
> 
> Am 17.04.2013 12:53, schrieb Liu Shengzhou-B36685:
> >Hi Braun,
> >
> >It seems the duplicated tdi_reset caused the PHY_CLK_VALID bit
> >unstable,
> >introduced by patch "EHCI: centralize controller initialization".
> >I submitted a patch to fix it.
> >Please review the patch http://patchwork.ozlabs.org/patch/237201/
> >
> >Regards,
> >Shengzhou
> >
> >
> >>-----Original Message-----
> >>From: Michael Braun [mailto:michael-dev@fami-braun.de]
> >>Sent: Wednesday, April 17, 2013 6:08 PM
> >>To: Liu Shengzhou-B36685
> >>Cc: Alan Stern; projekt-wlan@fem.tu-ilmenau.de; Greg Kroah-Hartman;
> >>linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org
> >>Subject: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
> >>Freescale P1020
> >>
> >>Hi,
> >>
> >>I'm running OpenWRT Kernel 3.8.3 (which already has
> >>f66dea709cd9309b2ee9f715697818001fb518de and
> >>5ed338778f917a035f0f0a52327fc4f72e36f7a1 applied) on a P1020WLAN
> >>(QorlQ,
> >>PPC) device.
> >>Before updating the kernel from 3.3.0, USB host support was
> >>working fine.
> >>Now I get "fsl-ehci: USB PHY clock invalid" messages in dmesg and the
> >>lsusb output is empty, so USB host support is not working. When
> >>I apply
> >>the following patch, USB host support starts working again, so I
> >>guess
> >>3735ba8db8e6ea22ad3ff524328926d8d780a884 is the cause.
> >>Do you have an idea how to fix it more appropriately?
> >>
> >>Thanks,
> >>  M. Braun
> >>
> >>--- a/drivers/usb/host/ehci-fsl.c       2013-04-15 21:13:52.924403077
> >>+0200
> >>+++ b/drivers/usb/host/ehci-fsl.c       2013-04-15 21:13:57.572410838
> >>+0200
> >>@@ -273,7 +273,6 @@ static int ehci_fsl_setup_phy(struct usb
> >>                 if (!spin_event_timeout(in_be32(non_ehci +
> >>FSL_SOC_USB_CTRL) &
> >>                                 PHY_CLK_VALID,
> >>FSL_USB_PHY_CLK_TIMEOUT,
> >>0)) {
> >>                         printk(KERN_WARNING "fsl-ehci: USB PHY clock
> >>invalid\n");
> >>-                       return -EINVAL;
> >>                 }
> >>         }
> >>
