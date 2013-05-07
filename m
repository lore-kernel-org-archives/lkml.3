Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753311Ab3EGOVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 10:21:32 -0400
Received: from ip4-83-240-18-99.cust.nbox.cz ([83.240.18.99]:59343 "EHLO
	anemoi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752700Ab3EGOSD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 10:18:03 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 13/15] chipidea: Allow user to select PCI/IMX options
Date: Tue,  7 May 2013 16:18:21 +0200
Message-Id: <1367936303-13386-13-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jeff Mahoney <jeffm@suse.com>

The chipidea driver currently has needless ifneq rules in the makefile
for things that should be config options. This can be problematic,
especially in the IMX case, since the OF_DEVICE dependency will be met
on powerpc systems - which don't actually support the hardware via that
method.

This patch adds _PCI and _IMX config options to allow the user to
select whether to build the modules.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/chipidea/Kconfig  | 11 +++++++++++
 drivers/usb/chipidea/Makefile | 11 ++---------
 2 files changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/chipidea/Kconfig b/drivers/usb/chipidea/Kconfig
index 608a2ae..1ac9bc2 100644
--- a/drivers/usb/chipidea/Kconfig
+++ b/drivers/usb/chipidea/Kconfig
@@ -31,4 +31,15 @@ config USB_CHIPIDEA_DEBUG
 	help
 	  Say Y here to enable debugging output of the ChipIdea driver.
 
+config USB_CHIPIDEA_PCI
+	bool "ChipIdea PCI support"
+	depends on PCI
+	help
+	  This option enables ChipIdea support on PCI.
+
+config USB_CHIPIDEA_IMX
+	bool "ChipIdea IMX support"
+	depends on OF_DEVICE
+	help
+	  This option enables ChipIdea support on IMX.
 endif
diff --git a/drivers/usb/chipidea/Makefile b/drivers/usb/chipidea/Makefile
index 4ab83e9..a97d103 100644
--- a/drivers/usb/chipidea/Makefile
+++ b/drivers/usb/chipidea/Makefile
@@ -10,12 +10,5 @@ ci_hdrc-$(CONFIG_USB_CHIPIDEA_DEBUG)	+= debug.o
 # Glue/Bridge layers go here
 
 obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_msm.o
-
-# PCI doesn't provide stubs, need to check
-ifneq ($(CONFIG_PCI),)
-	obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_pci.o
-endif
-
-ifneq ($(CONFIG_OF_DEVICE),)
-	obj-$(CONFIG_USB_CHIPIDEA)	+= ci13xxx_imx.o usbmisc_imx.o
-endif
+obj-$(CONFIG_USB_CHIPIDEA_PCI)	+= ci13xxx_pci.o
+obj-$(CONFIG_USB_CHIPIDEA_IMX)	+= ci13xxx_imx.o usbmisc_imx.o
-- 
1.8.2.1

