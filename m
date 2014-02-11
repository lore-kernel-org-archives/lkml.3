Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaBKMXN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:23:13 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:64229 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751004AbaBKMXJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:23:09 -0500
Message-ID: <1392121387.13064.3.camel@x220>
Subject: [PATCH] USB: ELAN: Remove useless "default M" lines
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Martin Walch <walch.martin@web.de>, Richard Weinberger <richard@nod.at>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 11 Feb 2014 13:23:07 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Feb 2014 12:23:07.0866 (UTC) FILETIME=[0552EBA0:01CF2724]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig entries for USB_U132_HCD and USB_FTDI_ELAN default to
(uppercase) "M". But in Kconfig (lowercase) "m" is a magic symbol. "M"
is an ordinary symbol. As "M" is never set these Kconfig symbols will
also not be set by default.

Since I'm not aware of a reason why these driver should be set by
default, let's just drop these lines (that basically do nothing).

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
This patch deserves a
    Reported-by: Martin Walch <walch.martin@web.de>

line, but that apparently requires Martin's permission.

 drivers/usb/host/Kconfig | 1 -
 drivers/usb/misc/Kconfig | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/usb/host/Kconfig b/drivers/usb/host/Kconfig
index a9707da..e22b826 100644
--- a/drivers/usb/host/Kconfig
+++ b/drivers/usb/host/Kconfig
@@ -584,7 +584,6 @@ config FHCI_DEBUG
 config USB_U132_HCD
 	tristate "Elan U132 Adapter Host Controller"
 	depends on USB_FTDI_ELAN
-	default M
 	help
 	  The U132 adapter is a USB to CardBus adapter specifically designed
 	  for PC cards that contain an OHCI host controller. Typical PC cards
diff --git a/drivers/usb/misc/Kconfig b/drivers/usb/misc/Kconfig
index ba5f70f..1bca274 100644
--- a/drivers/usb/misc/Kconfig
+++ b/drivers/usb/misc/Kconfig
@@ -128,7 +128,6 @@ config USB_IDMOUSE
 
 config USB_FTDI_ELAN
 	tristate "Elan PCMCIA CardBus Adapter USB Client"
-	default M
 	help
 	  ELAN's Uxxx series of adapters are USB to PCMCIA CardBus adapters.
 	  Currently only the U132 adapter is available.
-- 
1.8.5.3

