Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3DOURS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:17:18 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:33254 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754351Ab3DOURQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:17:16 -0400
X-RZG-AUTH: :P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBBWYxhJvJPtnXtogBWn6YvUkYzDKvBT07wx/0LJ4BNA==
X-RZG-CLASS-ID: mo00
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Mon, 15 Apr 2013 22:16:57 +0200
From: Michael Braun <michael.braun@fem.tu-ilmenau.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <projekt-wlan@fem.tu-ilmenau.de>
Subject: Regression in 3735ba8db8e6ea22ad3ff524328926d8d780a884 with
 Freescale P1020
Reply-To: <projekt-wlan@fem.tu-ilmenau.de>
Mail-Reply-To: <projekt-wlan@fem.tu-ilmenau.de>
Message-ID: <ee76d61e1b4c516ddb933fa533c3443c@fami-braun.de>
User-Agent: Roundcube Webmail/0.8.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running OpenWRT Kernel 3.8.3 (which already has 
f66dea709cd9309b2ee9f715697818001fb518de and 
5ed338778f917a035f0f0a52327fc4f72e36f7a1 applied) on a P1020WLAN (QorlQ, 
PPC) device.
Before updating the kernel from 3.3.0, USB host support was working 
fine. Now I get "fsl-ehci: USB PHY clock invalid" messages in dmesg and 
the lsusb output is empty, so USB host support is not working. When I 
apply the following patch, USB host support starts working again, so I 
guess 3735ba8db8e6ea22ad3ff524328926d8d780a884 is the cause.

Regards,
  M. Braun

--- a/drivers/usb/host/ehci-fsl.c       2013-04-15 21:13:52.924403077 
+0200
+++ b/drivers/usb/host/ehci-fsl.c       2013-04-15 21:13:57.572410838 
+0200
@@ -273,7 +273,6 @@ static int ehci_fsl_setup_phy(struct usb
                 if (!spin_event_timeout(in_be32(non_ehci + 
FSL_SOC_USB_CTRL) &
                                 PHY_CLK_VALID, FSL_USB_PHY_CLK_TIMEOUT, 
0)) {
                         printk(KERN_WARNING "fsl-ehci: USB PHY clock 
invalid\n");
-                       return -EINVAL;
                 }
         }


