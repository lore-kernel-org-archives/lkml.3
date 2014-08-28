Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934075AbaH1FbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 01:31:07 -0400
Received: from sub5.mail.dreamhost.com ([208.113.200.129]:50594 "EHLO
	homiemail-a47.g.dreamhost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932473AbaH1FbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 01:31:05 -0400
X-Greylist: delayed 171740 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2014 01:31:05 EDT
From: Shea Levy <shea@shealevy.com>
To: Felipe Balbi <balbi@ti.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Shea Levy <shea@shealevy.com>
Subject: [PATCH 1/1] usb: gadget: Remove use of PWD in Makefiles
Date: Thu, 28 Aug 2014 01:30:46 -0400
Message-Id: <1409203846-11007-1-git-send-email-shea@shealevy.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using PWD breaks out-of-tree builds in certain circumstances [1], and
other kernel Makefiles use relative paths just fine.

[1]: https://bugzilla.kernel.org/show_bug.cgi?id=83251

Signed-off-by: Shea Levy <shea@shealevy.com>
---
 drivers/usb/gadget/Makefile          | 2 +-
 drivers/usb/gadget/function/Makefile | 4 ++--
 drivers/usb/gadget/legacy/Makefile   | 6 +++---
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/usb/gadget/Makefile b/drivers/usb/gadget/Makefile
index a186afe..9add915 100644
--- a/drivers/usb/gadget/Makefile
+++ b/drivers/usb/gadget/Makefile
@@ -3,7 +3,7 @@
 #
 subdir-ccflags-$(CONFIG_USB_GADGET_DEBUG)	:= -DDEBUG
 subdir-ccflags-$(CONFIG_USB_GADGET_VERBOSE)	+= -DVERBOSE_DEBUG
-ccflags-y				+= -I$(PWD)/drivers/usb/gadget/udc
+ccflags-y				+= -Idrivers/usb/gadget/udc
 
 obj-$(CONFIG_USB_LIBCOMPOSITE)	+= libcomposite.o
 libcomposite-y			:= usbstring.o config.o epautoconf.o
diff --git a/drivers/usb/gadget/function/Makefile b/drivers/usb/gadget/function/Makefile
index 6d91f21..83ae106 100644
--- a/drivers/usb/gadget/function/Makefile
+++ b/drivers/usb/gadget/function/Makefile
@@ -2,8 +2,8 @@
 # USB peripheral controller drivers
 #
 
-ccflags-y			:= -I$(PWD)/drivers/usb/gadget/
-ccflags-y			+= -I$(PWD)/drivers/usb/gadget/udc/
+ccflags-y			:= -Idrivers/usb/gadget/
+ccflags-y			+= -Idrivers/usb/gadget/udc/
 
 # USB Functions
 usb_f_acm-y			:= f_acm.o
diff --git a/drivers/usb/gadget/legacy/Makefile b/drivers/usb/gadget/legacy/Makefile
index a11aad5..edba2d1 100644
--- a/drivers/usb/gadget/legacy/Makefile
+++ b/drivers/usb/gadget/legacy/Makefile
@@ -2,9 +2,9 @@
 # USB gadget drivers
 #
 
-ccflags-y			:= -I$(PWD)/drivers/usb/gadget/
-ccflags-y			+= -I$(PWD)/drivers/usb/gadget/udc/
-ccflags-y			+= -I$(PWD)/drivers/usb/gadget/function/
+ccflags-y			:= -Idrivers/usb/gadget/
+ccflags-y			+= -Idrivers/usb/gadget/udc/
+ccflags-y			+= -Idrivers/usb/gadget/function/
 
 g_zero-y			:= zero.o
 g_audio-y			:= audio.o
-- 
2.1.0

