Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752603AbaDWXrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 19:47:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:58953 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751543AbaDWXrT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 19:47:19 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
To: <linux-kernel@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kumar Gala <galak@codeaurora.org>, Paul Walmsley <paul@pwsan.com>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Sandeep Nair <sandeep_n@ti.com>
Subject: [PATCH v2 1/6] soc: Introduce drivers/soc place-holder for SOC specific drivers
Date: Wed, 23 Apr 2014 19:46:17 -0400
Message-ID: <1398296783-1176-2-git-send-email-santosh.shilimkar@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
References: <1398296783-1176-1-git-send-email-santosh.shilimkar@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on earlier thread "https://lkml.org/lkml/2013/10/7/662" and
discussion at Kernel Summit'2013, it was agreed to create
'driver/soc' for drivers which are quite SOC specific.

Further discussion on the subject is in response to
the earlier version of the patch is here:
	http://lwn.net/Articles/588942/

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kumar Gala <galak@codeaurora.org>
Cc: Paul Walmsley <paul@pwsan.com>
Cc: Olof Johansson <olof@lixom.net>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sandeep Nair <sandeep_n@ti.com>
Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
---
 drivers/Kconfig     |    2 ++
 drivers/Makefile    |    3 +++
 drivers/soc/Kconfig |    3 +++
 3 files changed, 8 insertions(+)
 create mode 100644 drivers/soc/Kconfig

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 0a0a90f..0e87a34 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -132,6 +132,8 @@ source "drivers/staging/Kconfig"
 
 source "drivers/platform/Kconfig"
 
+source "drivers/soc/Kconfig"
+
 source "drivers/clk/Kconfig"
 
 source "drivers/hwspinlock/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index e3ced91..5367b51 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -33,6 +33,9 @@ obj-y				+= amba/
 # really early.
 obj-$(CONFIG_DMADEVICES)	+= dma/
 
+# SOC specific infrastructure drivers.
+obj-y				+= soc/
+
 obj-$(CONFIG_VIRTIO)		+= virtio/
 obj-$(CONFIG_XEN)		+= xen/
 
diff --git a/drivers/soc/Kconfig b/drivers/soc/Kconfig
new file mode 100644
index 0000000..339baa8
--- /dev/null
+++ b/drivers/soc/Kconfig
@@ -0,0 +1,3 @@
+menu "SOC (System On Chip) specific Drivers"
+
+endmenu
-- 
1.7.9.5

