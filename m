Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab3I2TsE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 15:48:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59480 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755773Ab3I2T2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 15:28:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Randy Dunlap <rdunlap@infradead.org>
Subject: [ 37/49] Properly handle tristate dependencies on USB/PCI menus
Date: Sun, 29 Sep 2013 12:27:11 -0700
Message-Id: <20130929191605.522208598@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.6.g82e253f.dirty
In-Reply-To: <20130929191603.008825488@linuxfoundation.org>
References: <20130929191603.008825488@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mauro Carvalho Chehab <mchehab@redhat.com>

commit 5077ac3b8108007f4a2b4589f2d373cf55453206 upstream.

As USB/PCI/MEDIA_SUPPORT dependencies can be tristate, we can't
simply make the bool menu to be dependent on it. Everything below
the menu should also depend on it, otherwise, we risk to allow
building them with 'y', while only 'm' would be supported.

So, add an IF just before everything below, in order to avoid
such risks.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/Kconfig |    4 +++-
 drivers/media/usb/Kconfig |    3 +--
 2 files changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/pci/Kconfig
+++ b/drivers/media/pci/Kconfig
@@ -1,6 +1,7 @@
+if PCI && MEDIA_SUPPORT
+
 menuconfig MEDIA_PCI_SUPPORT
 	bool "Media PCI Adapters"
-	depends on PCI && MEDIA_SUPPORT
 	help
 	  Enable media drivers for PCI/PCIe bus.
 	  If you have such devices, say Y.
@@ -45,3 +46,4 @@ source "drivers/media/pci/ddbridge/Kconf
 endif
 
 endif #MEDIA_PCI_SUPPORT
+endif #PCI
--- a/drivers/media/usb/Kconfig
+++ b/drivers/media/usb/Kconfig
@@ -1,8 +1,7 @@
-if USB
+if USB && MEDIA_SUPPORT
 
 menuconfig MEDIA_USB_SUPPORT
 	bool "Media USB Adapters"
-	depends on MEDIA_SUPPORT
 	help
 	  Enable media drivers for USB bus.
 	  If you have such devices, say Y.


