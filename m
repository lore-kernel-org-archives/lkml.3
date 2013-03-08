Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab3CHJs5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 04:48:57 -0500
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:51858 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933454Ab3CHJs4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 04:48:56 -0500
Message-ID: <1362736134.5994.43.camel@x61.thuisdomein>
Subject: [PATCH] usb: gadget: get rid of two outdated selects
From: Paul Bolle <pebolle@tiscali.nl>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Mar 2013 10:48:54 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 08 Mar 2013 09:48:54.0763 (UTC) FILETIME=[259873B0:01CE1BE2]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbols USB_GADGET_DUALSPEED and USB_GADGET_SUPERSPEED were
removed in commit 85b8614d722389202af298e1bf8a599c431fef19 ("usb:
gadget: get rid of USB_GADGET_{DUAL,SUPER}SPEED"). These two select
statements somehow escaped cleaning up. Get rid of these too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep" only.

 drivers/usb/gadget/Kconfig | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 5a0c541..8a5af9b 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -329,8 +329,6 @@ config USB_MV_UDC
 config USB_MV_U3D
 	tristate "MARVELL PXA2128 USB 3.0 controller"
 	depends on CPU_MMP3
-	select USB_GADGET_DUALSPEED
-	select USB_GADGET_SUPERSPEED
 	help
 	  MARVELL PXA2128 Processor series include a super speed USB3.0 device
 	  controller, which support super speed USB peripheral.
-- 
1.7.11.7

