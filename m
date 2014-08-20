Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752147AbaHTEbo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 00:31:44 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:48923 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaHTEb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 00:31:29 -0400
From: Valentina Manea <valentina.manea.m@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tulinizer@gmail.com, stern@rowland.harvard.edu, mail@beyermatthias.de,
        hdegoede@redhat.com, f.manzan@gmail.com, kurt@garloff.de,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        firefly@lists.rosedu.org, andy.grover@gmail.com, max@vozeler.com,
        shuahkhan@gmail.com, Valentina Manea <valentina.manea.m@gmail.com>
Subject: [PATCH 2/4] usbip: move usbip kernel code out of staging
Date: Wed, 20 Aug 2014 07:31:00 +0300
Message-Id: <1408509062-1375-3-git-send-email-valentina.manea.m@gmail.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1408509062-1375-1-git-send-email-valentina.manea.m@gmail.com>
References: <1408509062-1375-1-git-send-email-valentina.manea.m@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At this point, USB/IP kernel code is fully functional
and can be moved out of staging.

Signed-off-by: Valentina Manea <valentina.manea.m@gmail.com>
---
 drivers/staging/Kconfig                                    | 2 --
 drivers/staging/Makefile                                   | 1 -
 drivers/usb/Kconfig                                        | 2 ++
 drivers/usb/Makefile                                       | 2 ++
 drivers/{staging => usb}/usbip/Kconfig                     | 0
 drivers/{staging => usb}/usbip/Makefile                    | 0
 drivers/{staging => usb}/usbip/README                      | 0
 drivers/{staging => usb}/usbip/stub.h                      | 0
 drivers/{staging => usb}/usbip/stub_dev.c                  | 0
 drivers/{staging => usb}/usbip/stub_main.c                 | 0
 drivers/{staging => usb}/usbip/stub_rx.c                   | 0
 drivers/{staging => usb}/usbip/stub_tx.c                   | 0
 drivers/{staging => usb}/usbip/usbip_common.c              | 0
 drivers/{staging => usb}/usbip/usbip_common.h              | 2 +-
 drivers/{staging => usb}/usbip/usbip_event.c               | 0
 drivers/{staging => usb}/usbip/usbip_protocol.txt          | 0
 drivers/{staging => usb}/usbip/vhci.h                      | 0
 drivers/{staging => usb}/usbip/vhci_hcd.c                  | 0
 drivers/{staging => usb}/usbip/vhci_rx.c                   | 0
 drivers/{staging => usb}/usbip/vhci_sysfs.c                | 0
 drivers/{staging => usb}/usbip/vhci_tx.c                   | 0
 {drivers/staging/usbip/uapi => include/uapi/linux}/usbip.h | 0
 22 files changed, 5 insertions(+), 4 deletions(-)
 rename drivers/{staging => usb}/usbip/Kconfig (100%)
 rename drivers/{staging => usb}/usbip/Makefile (100%)
 rename drivers/{staging => usb}/usbip/README (100%)
 rename drivers/{staging => usb}/usbip/stub.h (100%)
 rename drivers/{staging => usb}/usbip/stub_dev.c (100%)
 rename drivers/{staging => usb}/usbip/stub_main.c (100%)
 rename drivers/{staging => usb}/usbip/stub_rx.c (100%)
 rename drivers/{staging => usb}/usbip/stub_tx.c (100%)
 rename drivers/{staging => usb}/usbip/usbip_common.c (100%)
 rename drivers/{staging => usb}/usbip/usbip_common.h (99%)
 rename drivers/{staging => usb}/usbip/usbip_event.c (100%)
 rename drivers/{staging => usb}/usbip/usbip_protocol.txt (100%)
 rename drivers/{staging => usb}/usbip/vhci.h (100%)
 rename drivers/{staging => usb}/usbip/vhci_hcd.c (100%)
 rename drivers/{staging => usb}/usbip/vhci_rx.c (100%)
 rename drivers/{staging => usb}/usbip/vhci_sysfs.c (100%)
 rename drivers/{staging => usb}/usbip/vhci_tx.c (100%)
 rename {drivers/staging/usbip/uapi => include/uapi/linux}/usbip.h (100%)

diff --git a/drivers/staging/Kconfig b/drivers/staging/Kconfig
index 2c486ea..35b494f 100644
--- a/drivers/staging/Kconfig
+++ b/drivers/staging/Kconfig
@@ -28,8 +28,6 @@ source "drivers/staging/et131x/Kconfig"
 
 source "drivers/staging/slicoss/Kconfig"
 
-source "drivers/staging/usbip/Kconfig"
-
 source "drivers/staging/wlan-ng/Kconfig"
 
 source "drivers/staging/comedi/Kconfig"
diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
index 1e1a3a1..e66a5db 100644
--- a/drivers/staging/Makefile
+++ b/drivers/staging/Makefile
@@ -6,7 +6,6 @@ obj-$(CONFIG_STAGING)		+= staging.o
 obj-y				+= media/
 obj-$(CONFIG_ET131X)		+= et131x/
 obj-$(CONFIG_SLICOSS)		+= slicoss/
-obj-$(CONFIG_USBIP_CORE)	+= usbip/
 obj-$(CONFIG_PRISM2_USB)	+= wlan-ng/
 obj-$(CONFIG_COMEDI)		+= comedi/
 obj-$(CONFIG_FB_OLPC_DCON)	+= olpc_dcon/
diff --git a/drivers/usb/Kconfig b/drivers/usb/Kconfig
index e0cad44..cf1b19b 100644
--- a/drivers/usb/Kconfig
+++ b/drivers/usb/Kconfig
@@ -92,6 +92,8 @@ source "drivers/usb/storage/Kconfig"
 
 source "drivers/usb/image/Kconfig"
 
+source "drivers/usb/usbip/Kconfig"
+
 endif
 
 source "drivers/usb/musb/Kconfig"
diff --git a/drivers/usb/Makefile b/drivers/usb/Makefile
index 3cba892..d7be717 100644
--- a/drivers/usb/Makefile
+++ b/drivers/usb/Makefile
@@ -60,3 +60,5 @@ obj-$(CONFIG_USB_RENESAS_USBHS)	+= renesas_usbhs/
 obj-$(CONFIG_USB_GADGET)	+= gadget/
 
 obj-$(CONFIG_USB_COMMON)	+= common/
+
+obj-$(CONFIG_USBIP_CORE)	+= usbip/
diff --git a/drivers/staging/usbip/Kconfig b/drivers/usb/usbip/Kconfig
similarity index 100%
rename from drivers/staging/usbip/Kconfig
rename to drivers/usb/usbip/Kconfig
diff --git a/drivers/staging/usbip/Makefile b/drivers/usb/usbip/Makefile
similarity index 100%
rename from drivers/staging/usbip/Makefile
rename to drivers/usb/usbip/Makefile
diff --git a/drivers/staging/usbip/README b/drivers/usb/usbip/README
similarity index 100%
rename from drivers/staging/usbip/README
rename to drivers/usb/usbip/README
diff --git a/drivers/staging/usbip/stub.h b/drivers/usb/usbip/stub.h
similarity index 100%
rename from drivers/staging/usbip/stub.h
rename to drivers/usb/usbip/stub.h
diff --git a/drivers/staging/usbip/stub_dev.c b/drivers/usb/usbip/stub_dev.c
similarity index 100%
rename from drivers/staging/usbip/stub_dev.c
rename to drivers/usb/usbip/stub_dev.c
diff --git a/drivers/staging/usbip/stub_main.c b/drivers/usb/usbip/stub_main.c
similarity index 100%
rename from drivers/staging/usbip/stub_main.c
rename to drivers/usb/usbip/stub_main.c
diff --git a/drivers/staging/usbip/stub_rx.c b/drivers/usb/usbip/stub_rx.c
similarity index 100%
rename from drivers/staging/usbip/stub_rx.c
rename to drivers/usb/usbip/stub_rx.c
diff --git a/drivers/staging/usbip/stub_tx.c b/drivers/usb/usbip/stub_tx.c
similarity index 100%
rename from drivers/staging/usbip/stub_tx.c
rename to drivers/usb/usbip/stub_tx.c
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/usb/usbip/usbip_common.c
similarity index 100%
rename from drivers/staging/usbip/usbip_common.c
rename to drivers/usb/usbip/usbip_common.c
diff --git a/drivers/staging/usbip/usbip_common.h b/drivers/usb/usbip/usbip_common.h
similarity index 99%
rename from drivers/staging/usbip/usbip_common.h
rename to drivers/usb/usbip/usbip_common.h
index 4da3866..86b0847 100644
--- a/drivers/staging/usbip/usbip_common.h
+++ b/drivers/usb/usbip/usbip_common.h
@@ -29,7 +29,7 @@
 #include <linux/types.h>
 #include <linux/usb.h>
 #include <linux/wait.h>
-#include "uapi/usbip.h"
+#include <uapi/linux/usbip.h>
 
 #define USBIP_VERSION "1.0.0"
 
diff --git a/drivers/staging/usbip/usbip_event.c b/drivers/usb/usbip/usbip_event.c
similarity index 100%
rename from drivers/staging/usbip/usbip_event.c
rename to drivers/usb/usbip/usbip_event.c
diff --git a/drivers/staging/usbip/usbip_protocol.txt b/drivers/usb/usbip/usbip_protocol.txt
similarity index 100%
rename from drivers/staging/usbip/usbip_protocol.txt
rename to drivers/usb/usbip/usbip_protocol.txt
diff --git a/drivers/staging/usbip/vhci.h b/drivers/usb/usbip/vhci.h
similarity index 100%
rename from drivers/staging/usbip/vhci.h
rename to drivers/usb/usbip/vhci.h
diff --git a/drivers/staging/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
similarity index 100%
rename from drivers/staging/usbip/vhci_hcd.c
rename to drivers/usb/usbip/vhci_hcd.c
diff --git a/drivers/staging/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
similarity index 100%
rename from drivers/staging/usbip/vhci_rx.c
rename to drivers/usb/usbip/vhci_rx.c
diff --git a/drivers/staging/usbip/vhci_sysfs.c b/drivers/usb/usbip/vhci_sysfs.c
similarity index 100%
rename from drivers/staging/usbip/vhci_sysfs.c
rename to drivers/usb/usbip/vhci_sysfs.c
diff --git a/drivers/staging/usbip/vhci_tx.c b/drivers/usb/usbip/vhci_tx.c
similarity index 100%
rename from drivers/staging/usbip/vhci_tx.c
rename to drivers/usb/usbip/vhci_tx.c
diff --git a/drivers/staging/usbip/uapi/usbip.h b/include/uapi/linux/usbip.h
similarity index 100%
rename from drivers/staging/usbip/uapi/usbip.h
rename to include/uapi/linux/usbip.h
-- 
1.8.1.2

