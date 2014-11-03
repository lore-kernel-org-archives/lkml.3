Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038AbaKCUsO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 15:48:14 -0500
Received: from mga14.intel.com ([192.55.52.115]:55535 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbaKCUr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 15:47:58 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,308,1413270000"; 
   d="scan'208";a="616331457"
From: Stephanie Wallick <stephanie.s.wallick@intel.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        "Sean O. Stalley" <sean.stalley@intel.com>
Subject: [PATCH 10/10] added kernel build, configuration, and TODO files
Date: Mon,  3 Nov 2014 12:42:57 -0800
Message-Id: <1415047377-3139-11-git-send-email-stephanie.s.wallick@intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
References: <MA USB drivers>
 <1415047377-3139-1-git-send-email-stephanie.s.wallick@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Sean O. Stalley <sean.stalley@intel.com>
Signed-off-by: Stephanie Wallick <stephanie.s.wallick@intel.com>
---
 drivers/staging/Kconfig                |  2 ++
 drivers/staging/Makefile               |  1 +
 drivers/staging/mausb/Kconfig          | 16 ++++++++++++++++
 drivers/staging/mausb/Makefile         |  3 +++
 drivers/staging/mausb/TODO             | 14 ++++++++++++++
 drivers/staging/mausb/drivers/Kconfig  | 34 ++++++++++++++++++++++++++++++++++
 drivers/staging/mausb/drivers/Makefile | 20 ++++++++++++++++++++
 7 files changed, 90 insertions(+)
 create mode 100644 drivers/staging/mausb/Kconfig
 create mode 100644 drivers/staging/mausb/Makefile
 create mode 100644 drivers/staging/mausb/TODO
 create mode 100644 drivers/staging/mausb/drivers/Kconfig
 create mode 100644 drivers/staging/mausb/drivers/Makefile

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 35b494f..f57621b 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -24,6 +24,8 @@ menuconfig STAGING
 
 if STAGING
 
+source "drivers/staging/mausb/Kconfig"
+
 source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index e66a5db..7615c85 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -51,3 +51,4 @@ obj-$(CONFIG_GS_FPGABOOT)	+= gs_fpgaboot/
 obj-$(CONFIG_BT_NOKIA_H4P)	+= nokia_h4p/
 obj-$(CONFIG_CRYPTO_SKEIN)	+= skein/
 obj-$(CONFIG_UNISYSSPAR)	+= unisys/
+obj-$(CONFIG_MAUSB)		+= mausb/
diff --git a/drivers/staging/mausb/Kconfig b/drivers/staging/mausb/Kconfig
new file mode 100644
index 0000000..095c08b
--- /dev/null
+++ b/drivers/staging/mausb/Kconfig
@@ -0,0 +1,16 @@
+
+menuconfig MAUSB
+	bool "MA USB drivers"
+	depends on USB
+	---help---
+	  This option allows you to select from the various MA USB
+	  drivers. Note that a media-specific driver (e.g. tcp or SNAP)
+	  is needed in addition to the media agnostic host or device driver.
+
+
+if MAUSB
+
+source "drivers/staging/mausb/drivers/Kconfig"
+
+endif
+
diff --git a/drivers/staging/mausb/Makefile b/drivers/staging/mausb/Makefile
new file mode 100644
index 0000000..b559322
--- /dev/null
+++ b/drivers/staging/mausb/Makefile
@@ -0,0 +1,3 @@
+#obj-$(CONFIG_MAUSB) += drivers/
+obj-y += drivers/
+
diff --git a/drivers/staging/mausb/TODO b/drivers/staging/mausb/TODO
new file mode 100644
index 0000000..dd124ed
--- /dev/null
+++ b/drivers/staging/mausb/TODO
@@ -0,0 +1,14 @@
+TODO:
+	- checkpatch.pl cleanups
+	- address miscellaneous "TODO" statements in code
+	- add support for multiple media agnostic (MA) devices
+	- add/improve support for unimplemented packet types
+	- handle errors and failure with more grace and less crash
+
+Please send patches to Greg Kroah-Hartman <greg@kroah.com> and cc:
+
+	Sean Stalley <sean.stalley@intel.com>
+	Stephanie Wallick <stephanie.s.wallick@intel.com>
+
+
+
diff --git a/drivers/staging/mausb/drivers/Kconfig b/drivers/staging/mausb/drivers/Kconfig
new file mode 100644
index 0000000..9e12e22
--- /dev/null
+++ b/drivers/staging/mausb/drivers/Kconfig
@@ -0,0 +1,34 @@
+config MA_CORE
+	tristate "MA USB core"
+	---help---
+	  This builds ma_core module.
+
+config MAUSB_HOST
+	tristate "MA USB host"
+	depends on MA_CORE
+	---help---
+	  This builds MA USB host driver module.
+
+config MAUSB_DEVICE
+	tristate "MA USB device"
+	depends on MA_CORE && USB_GADGET
+	---help---
+	  This builds MA USB device driver module.
+
+config MATCP_CORE
+	tristate "MA USB tcp core"
+	---help---
+	  This builds tcp_core module.
+
+config MATCP_HOST
+	tristate "MA USB host tcp"
+	depends on MATCP_CORE
+	---help---
+	  This builds tcp_host module.
+
+config MATCP_DEVICE
+	tristate "MA USB device tcp"
+	depends on MATCP_CORE
+	---help---
+	  This builds tcp_dev module.
+
diff --git a/drivers/staging/mausb/drivers/Makefile b/drivers/staging/mausb/drivers/Makefile
new file mode 100644
index 0000000..a38491e
--- /dev/null
+++ b/drivers/staging/mausb/drivers/Makefile
@@ -0,0 +1,20 @@
+#MY_CFLAGS =-g -O0 -DEBUG_OUTPUT
+
+obj-$(CONFIG_MA_CORE) += ma_core.o
+ma_core-y := mausb_pkt.o mausb_tx.o mausb_msapi.o mausb_mem.o mausb_mgmt.o
+
+obj-$(CONFIG_MAUSB_HOST) += mausb.o
+mausb-y := mausb_hcd.o mausb_hub.o mausb_tx-host.o mausb_mem-host.o
+
+obj-$(CONFIG_MAUSB_DEVICE) += maudc.o
+maudc-y := mausb_udc.o mausb_tx-device.o
+
+obj-$(CONFIG_MATCP_HOST) += matcp_host.o
+matcp_host-y := mausb_tcp-host.o
+
+obj-$(CONFIG_MATCP_DEVICE) += matcp_dev.o
+matcp_dev-y := mausb_tcp-device.o
+
+obj-$(CONFIG_MATCP_CORE) += matcp_core.o
+matcp_core-y := mausb_tcp.o mausb_ioctl.o
+
-- 
1.9.1

