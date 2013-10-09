Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab3JIJuy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 05:50:54 -0400
Received: from demumfd001.nsn-inter.net ([93.183.12.32]:10328 "EHLO
	demumfd001.nsn-inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757179Ab3JIJuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 05:50:51 -0400
Message-ID: <525526F5.5030107@nsn.com>
Date: Wed, 09 Oct 2013 11:50:45 +0200
From: Ionut Nicu <ioan.nicu.ext@nsn.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Peter Korsgaard <peter.korsgaard@barco.com>
CC: Wolfram Sang <wsa@the-dreams.de>,
        Alexander Sverdlin <alexander.sverdlin@nsn.com>,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] i2c-mux-gpio: use deferred probing
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: clean
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate-size: 1098
X-purgate-ID: 151667::1381312246-00004A43-DB43D3BE/0-0/0-0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the i2c-parent bus driver is not loaded, returning
-ENODEV will force people to unload and then reload the
module again to get it working.

Signed-off-by: Ionut Nicu <ioan.nicu.ext@nsn.com>
---
 drivers/i2c/muxes/i2c-mux-gpio.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/muxes/i2c-mux-gpio.c b/drivers/i2c/muxes/i2c-mux-gpio.c
index 5d4a99b..ff184eb 100644
--- a/drivers/i2c/muxes/i2c-mux-gpio.c
+++ b/drivers/i2c/muxes/i2c-mux-gpio.c
@@ -79,7 +79,7 @@ static int i2c_mux_gpio_probe_dt(struct gpiomux *mux,
 	adapter = of_find_i2c_adapter_by_node(adapter_np);
 	if (!adapter) {
 		dev_err(&pdev->dev, "Cannot find parent bus\n");
-		return -ENODEV;
+		return -EPROBE_DEFER;
 	}
 	mux->data.parent = i2c_adapter_id(adapter);
 	put_device(&adapter->dev);
@@ -177,7 +177,7 @@ static int i2c_mux_gpio_probe(struct platform_device *pdev)
 	if (!parent) {
 		dev_err(&pdev->dev, "Parent adapter (%d) not found\n",
 			mux->data.parent);
-		return -ENODEV;
+		return -EPROBE_DEFER;
 	}
 
 	mux->parent = parent;
-- 
1.7.1

