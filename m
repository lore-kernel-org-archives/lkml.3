Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753529AbaBPTpo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Feb 2014 14:45:44 -0500
Received: from cpsmtpb-ews07.kpnxchange.com ([213.75.39.10]:55408 "EHLO
	cpsmtpb-ews07.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753283AbaBPTpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Feb 2014 14:45:43 -0500
Message-ID: <1392579941.28866.55.camel@x220>
Subject: [PATCH 1/2] usb: host: remove USB_ARCH_HAS_?HCI
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>
Cc: Richard Weinberger <richard@nod.at>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 16 Feb 2014 20:45:41 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 16 Feb 2014 19:45:42.0010 (UTC) FILETIME=[ACE47DA0:01CF2B4F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

USB_ARCH_HAS_EHCI, USB_ARCH_HAS_OHCI, and USB_ARCH_HAS_XHCI were made
obsolete in v3.11. They have not been used ever since. Setting them has
no effect. They can safely be removed.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
Tested with "git grep".

Note that the comment in this Kconfig file (that is also removed)
suggests to first remove the select statements for these symbols and
then the symbols themselves. But I think it makes more sense to first
delete these three symbols and then remove the selects statements (as
that is removing a second order effect). But it could just as well be
done with just one patch, I'd say.

 drivers/usb/Kconfig | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index 2e6b832..e0cad44 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -2,10 +2,6 @@
 # USB device configuration
 #
 
-# These are unused now, remove them once they are no longer selected
-config USB_ARCH_HAS_OHCI
-	bool
-
 config USB_OHCI_BIG_ENDIAN_DESC
 	bool
 
@@ -17,18 +13,12 @@ config USB_OHCI_LITTLE_ENDIAN
 	default n if STB03xxx || PPC_MPC52xx
 	default y
 
-config USB_ARCH_HAS_EHCI
-	bool
-
 config USB_EHCI_BIG_ENDIAN_MMIO
 	bool
 
 config USB_EHCI_BIG_ENDIAN_DESC
 	bool
 
-config USB_ARCH_HAS_XHCI
-	bool
-
 menuconfig USB_SUPPORT
 	bool "USB support"
 	depends on HAS_IOMEM
-- 
1.8.5.3

