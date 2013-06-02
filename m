Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755514Ab3FBWdN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jun 2013 18:33:13 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:40450 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3FBWdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jun 2013 18:33:03 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 3 Jun 2013 00:32:49 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: linux1394-devel@lists.sourceforge.net
Cc: Takashi Sakamoto <o-takashi@sakamocchi.jp>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] firewire: remove support of fw_driver.driver.probe and
 .remove methods
Message-ID: <20130603003249.5287b4c4@stein>
In-Reply-To: <20130603002749.4fdc36a5@stein>
References: <51A20AEE.7060201@sakamocchi.jp>
	<20130526233513.1a95d0d5@stein>
	<20130526225757.GA32606@kroah.com>
	<51A742A1.8010108@sakamocchi.jp>
	<20130603002749.4fdc36a5@stein>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After all drivers being converted to bus-specific .probe/.remove methods,
remove support of the obsolete generic methods.

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
To be merged maybe one release cycle after patch "firewire: introduce
fw_driver.probe and .remove methods".

 drivers/firewire/core-device.c |   12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -197,10 +197,7 @@ static int fw_unit_probe(struct device *
 	struct fw_driver *driver =
 			container_of(dev->driver, struct fw_driver, driver);
 
-	if (driver->probe)
-		return driver->probe(fw_unit(dev), unit_match(dev, dev->driver));
-	else
-		return driver->driver.probe(dev);
+	return driver->probe(fw_unit(dev), unit_match(dev, dev->driver));
 }
 
 static int fw_unit_remove(struct device *dev)
@@ -208,10 +205,9 @@ static int fw_unit_remove(struct device
 	struct fw_driver *driver =
 			container_of(dev->driver, struct fw_driver, driver);
 
-	if (driver->remove)
-		return driver->remove(fw_unit(dev)), 0;
-	else
-		return driver->driver.remove(dev);
+	driver->remove(fw_unit(dev));
+
+	return 0;
 }
 
 static int get_modalias(struct fw_unit *unit, char *buffer, size_t buffer_size)


-- 
Stefan Richter
-=====-===-= -==- ---==
http://arcgraph.de/sr/
