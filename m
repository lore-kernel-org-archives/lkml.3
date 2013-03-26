Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934382Ab3CZJf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 05:35:27 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:47018 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759783Ab3CZJfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 05:35:24 -0400
From: Fabio Porcedda <fabio.porcedda@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>,
        linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>
Subject: [PATCH 1/3] driver core: warn that platform_driver_probe can not use deferred probing
Date: Tue, 26 Mar 2013 10:35:15 +0100
Message-Id: <1364290517-8094-2-git-send-email-fabio.porcedda@gmail.com>
X-Mailer: git-send-email 1.8.2
In-Reply-To: <1364290517-8094-1-git-send-email-fabio.porcedda@gmail.com>
References: <1364290517-8094-1-git-send-email-fabio.porcedda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add documentation that platform_driver_probe() is incompatible with
deferred probing.

Signed-off-by: Fabio Porcedda <fabio.porcedda@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/base/platform.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c0b8df3..ef2afb1 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -555,7 +555,8 @@ EXPORT_SYMBOL_GPL(platform_driver_unregister);
 /**
  * platform_driver_probe - register driver for non-hotpluggable device
  * @drv: platform driver structure
- * @probe: the driver probe routine, probably from an __init section
+ * @probe: the driver probe routine, probably from an __init section,
+ *         must not return -EPROBE_DEFER.
  *
  * Use this instead of platform_driver_register() when you know the device
  * is not hotpluggable and has already been registered, and you want to
@@ -566,6 +567,9 @@ EXPORT_SYMBOL_GPL(platform_driver_unregister);
  * into system-on-chip processors, where the controller devices have been
  * configured as part of board setup.
  *
+ * This is incompatible with deferred probing so probe() must not
+ * return -EPROBE_DEFER.
+ *
  * Returns zero if the driver registered and bound to a device, else returns
  * a negative error code and with the driver not registered.
  */
-- 
1.8.2

