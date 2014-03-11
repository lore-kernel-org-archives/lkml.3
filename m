Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534AbaCKMuX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:50:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:59375 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784AbaCKMuV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:50:21 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,630,1389772800"; 
   d="scan'208";a="497652262"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc-next 1/3] mei: make me hw headers private to me hw.
Date: Tue, 11 Mar 2014 14:49:23 +0200
Message-Id: <1394542165-19362-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove includes of me-hw.h and me-hw-regs.h headers from
the mei generic code.
The mei layer should not depend on hw specific headers

Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/misc/mei/amthif.c    | 1 -
 drivers/misc/mei/bus.c       | 1 -
 drivers/misc/mei/hbm.c       | 1 -
 drivers/misc/mei/hw-me.c     | 4 ++--
 drivers/misc/mei/interrupt.c | 1 -
 drivers/misc/mei/main.c      | 1 -
 drivers/misc/mei/mei_dev.h   | 1 -
 drivers/misc/mei/pci-me.c    | 3 ++-
 drivers/misc/mei/wd.c        | 1 -
 9 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/misc/mei/amthif.c b/drivers/misc/mei/amthif.c
index f05d54d..b75a7da 100644
--- a/drivers/misc/mei/amthif.c
+++ b/drivers/misc/mei/amthif.c
@@ -34,7 +34,6 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "hw-me.h"
 #include "client.h"
 
 const uuid_le mei_amthif_guid  = UUID_LE(0x12f80028, 0xb4b7, 0x4b2d,
diff --git a/drivers/misc/mei/bus.c b/drivers/misc/mei/bus.c
index 463ae51..ddc5ac9 100644
--- a/drivers/misc/mei/bus.c
+++ b/drivers/misc/mei/bus.c
@@ -26,7 +26,6 @@
 #include <linux/mei_cl_bus.h>
 
 #include "mei_dev.h"
-#include "hw-me.h"
 #include "client.h"
 
 #define to_mei_cl_driver(d) container_of(d, struct mei_cl_driver, driver)
diff --git a/drivers/misc/mei/hbm.c b/drivers/misc/mei/hbm.c
index 9555791..5fa5ff9 100644
--- a/drivers/misc/mei/hbm.c
+++ b/drivers/misc/mei/hbm.c
@@ -21,7 +21,6 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "hw-me.h"
 #include "client.h"
 
 static const char *mei_cl_conn_status_str(enum mei_cl_connect_status status)
diff --git a/drivers/misc/mei/hw-me.c b/drivers/misc/mei/hw-me.c
index 7e769c5..d1994f6 100644
--- a/drivers/misc/mei/hw-me.c
+++ b/drivers/misc/mei/hw-me.c
@@ -20,10 +20,10 @@
 #include <linux/interrupt.h>
 
 #include "mei_dev.h"
-#include "hw-me.h"
-
 #include "hbm.h"
 
+#include "hw-me.h"
+#include "hw-me-regs.h"
 
 /**
  * mei_me_reg_read - Reads 32bit data from the mei device
diff --git a/drivers/misc/mei/interrupt.c b/drivers/misc/mei/interrupt.c
index 2fbf0c0..e9c3fa8 100644
--- a/drivers/misc/mei/interrupt.c
+++ b/drivers/misc/mei/interrupt.c
@@ -26,7 +26,6 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "hw-me.h"
 #include "client.h"
 
 
diff --git a/drivers/misc/mei/main.c b/drivers/misc/mei/main.c
index 49e3bb8..63ca2d1 100644
--- a/drivers/misc/mei/main.c
+++ b/drivers/misc/mei/main.c
@@ -40,7 +40,6 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
-#include "hw-me.h"
 #include "client.h"
 
 /**
diff --git a/drivers/misc/mei/mei_dev.h b/drivers/misc/mei/mei_dev.h
index 36640b9..2ef5593 100644
--- a/drivers/misc/mei/mei_dev.h
+++ b/drivers/misc/mei/mei_dev.h
@@ -24,7 +24,6 @@
 #include <linux/mei_cl_bus.h>
 
 #include "hw.h"
-#include "hw-me-regs.h"
 #include "hbm.h"
 
 /*
diff --git a/drivers/misc/mei/pci-me.c b/drivers/misc/mei/pci-me.c
index 50d9cb5..19fa183 100644
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -39,8 +39,9 @@
 #include <linux/mei.h>
 
 #include "mei_dev.h"
-#include "hw-me.h"
 #include "client.h"
+#include "hw-me-regs.h"
+#include "hw-me.h"
 
 /* mei_pci_tbl - PCI Device ID Table */
 static DEFINE_PCI_DEVICE_TABLE(mei_me_pci_tbl) = {
diff --git a/drivers/misc/mei/wd.c b/drivers/misc/mei/wd.c
index e084adf..ebf1cbc 100644
--- a/drivers/misc/mei/wd.c
+++ b/drivers/misc/mei/wd.c
@@ -25,7 +25,6 @@
 
 #include "mei_dev.h"
 #include "hbm.h"
-#include "hw-me.h"
 #include "client.h"
 
 static const u8 mei_start_wd_params[] = { 0x02, 0x12, 0x13, 0x10 };
-- 
1.8.5.3

