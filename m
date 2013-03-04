Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab3CDWwr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:52:47 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:51017 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758791Ab3CDWwq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:52:46 -0500
From: Nishanth Menon <nm@ti.com>
To: <linux-usb@vger.kernel.org>
CC: Nishanth Menon <nm@ti.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Kosina <trivial@kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: gadget: composite: fix kernel-doc warnings
Date: Mon, 4 Mar 2013 16:52:38 -0600
Message-ID: <1362437558-30782-1-git-send-email-nm@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few trivial fixes for composite driver.
Fixes:
Warning(include/linux/usb/composite.h:165): No description found for parameter 'fs_descriptors'
Warning(include/linux/usb/composite.h:165): Excess struct/union/enum/typedef member 'descriptors' description in 'usb_function'
Warning(include/linux/usb/composite.h:321): No description found for parameter 'gadget_driver'
Warning(drivers/usb/gadget/composite.c:1777): Excess function parameter 'bind' description in 'usb_composite_probe'

Cc: Felipe Balbi <balbi@ti.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Kosina <trivial@kernel.org>
Cc: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org

Signed-off-by: Nishanth Menon <nm@ti.com>
---
 drivers/usb/gadget/composite.c |    5 +----
 include/linux/usb/composite.h  |    3 ++-
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/gadget/composite.c b/drivers/usb/gadget/composite.c
index 7c821de..c0d62b2 100644
--- a/drivers/usb/gadget/composite.c
+++ b/drivers/usb/gadget/composite.c
@@ -1757,10 +1757,7 @@ static const struct usb_gadget_driver composite_driver_template = {
 /**
  * usb_composite_probe() - register a composite driver
  * @driver: the driver to register
- * @bind: the callback used to allocate resources that are shared across the
- *	whole device, such as string IDs, and add its configurations using
- *	@usb_add_config().  This may fail by returning a negative errno
- *	value; it should return zero on successful initialization.
+ *
  * Context: single threaded during gadget setup
  *
  * This function is used to register drivers using the composite driver
diff --git a/include/linux/usb/composite.h b/include/linux/usb/composite.h
index 3c671c1..8860594 100644
--- a/include/linux/usb/composite.h
+++ b/include/linux/usb/composite.h
@@ -60,7 +60,7 @@ struct usb_configuration;
  * @name: For diagnostics, identifies the function.
  * @strings: tables of strings, keyed by identifiers assigned during bind()
  *	and by language IDs provided in control requests
- * @descriptors: Table of full (or low) speed descriptors, using interface and
+ * @fs_descriptors: Table of full (or low) speed descriptors, using interface and
  *	string identifiers assigned during @bind().  If this pointer is null,
  *	the function will not be available at full speed (or at low speed).
  * @hs_descriptors: Table of high speed descriptors, using interface and
@@ -290,6 +290,7 @@ enum {
  *	after function notifications
  * @resume: Notifies configuration when the host restarts USB traffic,
  *	before function notifications
+ * @gadget_driver: Gadget driver controlling this driver
  *
  * Devices default to reporting self powered operation.  Devices which rely
  * on bus powered operation should report this in their @bind method.
-- 
1.7.9.5

