Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756077Ab3KLTHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 14:07:54 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:44241 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab3KLTHh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 14:07:37 -0500
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: [PATCH 09/12] usb: core: Remove superfluous name casts
Date: Tue, 12 Nov 2013 20:07:22 +0100
Message-Id: <1384283245-9419-10-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
References: <1384283245-9419-1-git-send-email-geert@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

device_driver.name is "const char *"

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org
---
 drivers/usb/core/driver.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/driver.c b/drivers/usb/core/driver.c
index 47aade2a5e74..8d989b1d3dc5 100644
--- a/drivers/usb/core/driver.c
+++ b/drivers/usb/core/driver.c
@@ -839,7 +839,7 @@ int usb_register_device_driver(struct usb_device_driver *new_udriver,
 		return -ENODEV;
 
 	new_udriver->drvwrap.for_devices = 1;
-	new_udriver->drvwrap.driver.name = (char *) new_udriver->name;
+	new_udriver->drvwrap.driver.name = new_udriver->name;
 	new_udriver->drvwrap.driver.bus = &usb_bus_type;
 	new_udriver->drvwrap.driver.probe = usb_probe_device;
 	new_udriver->drvwrap.driver.remove = usb_unbind_device;
@@ -900,7 +900,7 @@ int usb_register_driver(struct usb_driver *new_driver, struct module *owner,
 		return -ENODEV;
 
 	new_driver->drvwrap.for_devices = 0;
-	new_driver->drvwrap.driver.name = (char *) new_driver->name;
+	new_driver->drvwrap.driver.name = new_driver->name;
 	new_driver->drvwrap.driver.bus = &usb_bus_type;
 	new_driver->drvwrap.driver.probe = usb_probe_interface;
 	new_driver->drvwrap.driver.remove = usb_unbind_interface;
-- 
1.7.9.5

