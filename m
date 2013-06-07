Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab3FGHbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 03:31:39 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:1147 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab3FGHbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 03:31:37 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 07 Jun 2013 00:31:36 -0700
From: Alexandre Courbot <acourbot@nvidia.com>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Olof Johansson <olof@lixom.net>
CC: <gnurou@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-fbdev@vger.kernel.org>, Alexandre Courbot <acourbot@nvidia.com>
Subject: [PATCH v3] simplefb: add support for a8b8g8r8 pixel format
Date: Fri, 7 Jun 2013 16:31:30 +0900
Message-ID: <1370590290-13467-1-git-send-email-acourbot@nvidia.com>
X-Mailer: git-send-email 1.8.3
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A framebuffer of this format is set up by SHIELD's bootloader.

Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
Acked-by: Olof Johansson <olof@lixom.net>
---
Changes from v2:
- Fixed typo in format (Thanks Alexander van Heukelum!)

Changes from v1:
- Added description to motivate the change
- Added ack

 Documentation/devicetree/bindings/video/simple-framebuffer.txt | 1 +
 drivers/video/simplefb.c                                       | 1 +
 2 files changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/video/simple-framebuffer.txt b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
index 3ea4605..70c26f3 100644
--- a/Documentation/devicetree/bindings/video/simple-framebuffer.txt
+++ b/Documentation/devicetree/bindings/video/simple-framebuffer.txt
@@ -12,6 +12,7 @@ Required properties:
 - stride: The number of bytes in each line of the framebuffer.
 - format: The format of the framebuffer surface. Valid values are:
   - r5g6b5 (16-bit pixels, d[15:11]=r, d[10:5]=g, d[4:0]=b).
+  - a8b8g8r8 (32-bit pixels, d[31:24]=a, d[23:16]=b, d[15:8]=g, d[7:0]=r).
 
 Example:
 
diff --git a/drivers/video/simplefb.c b/drivers/video/simplefb.c
index e2e9e3e..f015482 100644
--- a/drivers/video/simplefb.c
+++ b/drivers/video/simplefb.c
@@ -84,6 +84,7 @@ struct simplefb_format {
 
 static struct simplefb_format simplefb_formats[] = {
 	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0} },
+	{ "a8b8g8r8", 32, {0, 8}, {8, 8}, {16, 8}, {24, 8} },
 };
 
 struct simplefb_params {
-- 
1.8.3

