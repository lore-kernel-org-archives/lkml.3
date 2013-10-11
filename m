Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3JKGHj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 02:07:39 -0400
Received: from vsp-authed02.binero.net ([195.74.38.226]:19405 "EHLO
	vsp-authed-03-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753022Ab3JKGHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 02:07:36 -0400
From: Andreas Larsson <andreas@gaisler.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, software@gaisler.com
Subject: [PATCH] usb: gadget: Make VERBOSE_DEBUG enableable via Kconfig
Date: Fri, 11 Oct 2013 08:07:00 +0200
Message-Id: <1381471620-22695-1-git-send-email-andreas@gaisler.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andreas Larsson <andreas@gaisler.com>
---
 drivers/usb/gadget/Kconfig  |   14 ++++++++++++++
 drivers/usb/gadget/Makefile |    3 ++-
 2 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 48cddf3..922a04d 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -58,6 +58,20 @@ config USB_GADGET_DEBUG
 	   trying to track down.  Never enable these messages for a
 	   production build.
 
+config USB_GADGET_VERBOSE
+	bool "Verbose debugging Messages (DEVELOPMENT)"
+	depends on USB_GADGET_DEBUG
+	help
+	   Many controller and gadget drivers will print verbose debugging
+	   messages if you use this option to ask for those messages.
+
+	   Avoid enabling these messages, even if you're actively
+	   debugging such a driver.  Many drivers will emit so many
+	   messages that the driver timings are affected, which will
+	   either create new failure modes or remove the one you're
+	   trying to track down.  Never enable these messages for a
+	   production build.
+
 config USB_GADGET_DEBUG_FILES
 	boolean "Debugging information files (DEVELOPMENT)"
 	depends on PROC_FS
diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index 386db9d..ba872ba 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -1,7 +1,8 @@
 #
 # USB peripheral controller drivers
 #
-ccflags-$(CONFIG_USB_GADGET_DEBUG) := -DDEBUG
+ccflags-$(CONFIG_USB_GADGET_DEBUG)	:= -DDEBUG
+ccflags-$(CONFIG_USB_GADGET_VERBOSE)	+= -DVERBOSE_DEBUG
 
 obj-$(CONFIG_USB_GADGET)	+= udc-core.o
 obj-$(CONFIG_USB_LIBCOMPOSITE)	+= libcomposite.o
-- 
1.7.10.4

