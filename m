Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab3ENKqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 06:46:35 -0400
Received: from mail-pd0-f169.google.com ([209.85.192.169]:38093 "EHLO
	mail-pd0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab3ENKqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 06:46:33 -0400
From: Lad Prabhakar <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Sakari Ailus <sakari.ailus@iki.fi>
Subject: [PATCH 2/5] media: i2c: tvp7002: rearrange description of structure members
Date: Tue, 14 May 2013 16:15:31 +0530
Message-Id: <1368528334-13595-3-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1368528334-13595-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1368528334-13595-1-git-send-email-prabhakar.csengg@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch rearranges the description of field members of
struct tvp7002_config. Also as the all the fields where accepting
a value either 0/1, made the members as bool.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
---
 include/media/tvp7002.h |   44 ++++++++++++++++++++------------------------
 1 files changed, 20 insertions(+), 24 deletions(-)

diff --git a/include/media/tvp7002.h b/include/media/tvp7002.h
index 7123048..fadb6af 100644
--- a/include/media/tvp7002.h
+++ b/include/media/tvp7002.h
@@ -28,31 +28,27 @@
 
 #define TVP7002_MODULE_NAME "tvp7002"
 
-/* Platform-dependent data
- *
- * clk_polarity:
- * 			0 -> data clocked out on rising edge of DATACLK signal
- * 			1 -> data clocked out on falling edge of DATACLK signal
- * hs_polarity:
- * 			0 -> active low HSYNC output
- * 			1 -> active high HSYNC output
- * sog_polarity:
- * 			0 -> normal operation
- * 			1 -> operation with polarity inverted
- * vs_polarity:
- * 			0 -> active low VSYNC output
- * 			1 -> active high VSYNC output
- * fid_polarity:
- *			0 -> the field ID output is set to logic 1 for an odd
- *			     field (field 1) and set to logic 0 for an even
- *			     field (field 0).
- *			1 -> operation with polarity inverted.
+/**
+ * struct tvp7002_config - Platform dependent data
+ *@clk_polarity: Clock polarity
+ *		0 - Data clocked out on rising edge of DATACLK signal
+ *		1 - Data clocked out on falling edge of DATACLK signal
+ *@hs_polarity:  HSYNC polarity
+ *		0 - Active low HSYNC output, 1 - Active high HSYNC output
+ *@vs_polarity: VSYNC Polarity
+ *		0 - Active low VSYNC output, 1 - Active high VSYNC output
+ *@fid_polarity: Active-high Field ID polarity.
+ *		0 - The field ID output is set to logic 1 for an odd field
+ *		    (field 1) and set to logic 0 for an even field (field 0).
+ *		1 - Operation with polarity inverted.
+ *@sog_polarity: Active high Sync on Green output polarity.
+ *		0 - Normal operation, 1 - Operation with polarity inverted
  */
 struct tvp7002_config {
-	u8 clk_polarity;
-	u8 hs_polarity;
-	u8 vs_polarity;
-	u8 fid_polarity;
-	u8 sog_polarity;
+	bool clk_polarity;
+	bool hs_polarity;
+	bool vs_polarity;
+	bool fid_polarity;
+	bool sog_polarity;
 };
 #endif
-- 
1.7.4.1

