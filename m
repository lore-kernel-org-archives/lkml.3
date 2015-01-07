Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbbAGHlg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 02:41:36 -0500
Received: from 7of9.schinagl.nl ([88.159.158.68]:42166 "EHLO 7of9.schinagl.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751618AbbAGHle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 02:41:34 -0500
From: Olliver Schinagl <oliver+list@schinagl.nl>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Olliver Schinagl <oliver@schinagl.nl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wolfram Sang <wsa@the-dreams.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        dev@linux-sunxi.org
Subject: [PATCH v1] ARM:sunxi:sid: Make use of the of_match_ptr
Date: Wed,  7 Jan 2015 08:41:08 +0100
Message-Id: <1420616468-3782-1-git-send-email-oliver+list@schinagl.nl>
X-Mailer: git-send-email 2.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olliver Schinagl <oliver@schinagl.nl>

I probably have forgotten to use this macro for the of_match pointer, so
this patch adds the of_match_ptr macro.

Signed-off-by: Olliver Schinagl <oliver@schinagl.nl>
---
 drivers/misc/eeprom/sunxi_sid.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/eeprom/sunxi_sid.c b/drivers/misc/eeprom/sunxi_sid.c
index 8385177..5a330d9 100644
--- a/drivers/misc/eeprom/sunxi_sid.c
+++ b/drivers/misc/eeprom/sunxi_sid.c
@@ -25,6 +25,7 @@
 #include <linux/kernel.h>
 #include <linux/kobject.h>
 #include <linux/module.h>
+#include <linux/of.h>
 #include <linux/of_device.h>
 #include <linux/platform_device.h>
 #include <linux/random.h>
@@ -146,7 +147,7 @@ static struct platform_driver sunxi_sid_driver = {
 	.remove = sunxi_sid_remove,
 	.driver = {
 		.name = DRV_NAME,
-		.of_match_table = sunxi_sid_of_match,
+		.of_match_table = of_match_ptr(sunxi_sid_of_match),
 	},
 };
 module_platform_driver(sunxi_sid_driver);
-- 
2.1.4

