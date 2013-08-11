Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab3HKGC7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 02:02:59 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:48602 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396Ab3HKGC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 02:02:57 -0400
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: LMML <linux-media@vger.kernel.org>, Hans Verkuil <hverkuil@xs4all.nl>
Cc: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: OF: add "sync-on-green-active" property
Date: Sun, 11 Aug 2013 11:32:24 +0530
Message-Id: <1376200944-20478-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

This patch adds 'sync-on-green-active' property as part
of endpoint property.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
---
  
  Changes for non RFC:
  1: Fixed review comments pointed by Hans.
  2: Added Ack from Sylwester.
  
  Changes for v5:
  1: Changed description for sync-on-green-active property in
     documentation file as suggested by Sylwester.
  
  Changes for v4:
  1: Fixed review comments pointed by Sylwester.

  Changes for v3:
  1: Fixed review comments pointed by Laurent and Sylwester.

  RFC v2 https://patchwork.kernel.org/patch/2578091/

  RFC V1 https://patchwork.kernel.org/patch/2572341/
  
 .../devicetree/bindings/media/video-interfaces.txt |    2 ++
 drivers/media/v4l2-core/v4l2-of.c                  |    4 ++++
 include/media/v4l2-mediabus.h                      |    3 +++
 3 files changed, 9 insertions(+)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index e022d2d..ce719f8 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -88,6 +88,8 @@ Optional endpoint properties
 - field-even-active: field signal level during the even field data transmission.
 - pclk-sample: sample data on rising (1) or falling (0) edge of the pixel clock
   signal.
+- sync-on-green-active: active state of Sync-on-green (SoG) signal, 0/1 for
+  LOW/HIGH respectively.
 - data-lanes: an array of physical data lane indexes. Position of an entry
   determines the logical lane number, while the value of an entry indicates
   physical lane, e.g. for 2-lane MIPI CSI-2 bus we could have
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index aa59639..5c4c9f0 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -100,6 +100,10 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 	if (!of_property_read_u32(node, "data-shift", &v))
 		bus->data_shift = v;
 
+	if (!of_property_read_u32(node, "sync-on-green-active", &v))
+		flags |= v ? V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH :
+			V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW;
+
 	bus->flags = flags;
 
 }
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 83ae07e..395c4a9 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -40,6 +40,9 @@
 #define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << 10)
 /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
 #define V4L2_MBUS_FIELD_EVEN_LOW		(1 << 11)
+/* Active state of Sync-on-green (SoG) signal, 0/1 for LOW/HIGH respectively. */
+#define V4L2_MBUS_VIDEO_SOG_ACTIVE_HIGH	(1 << 12)
+#define V4L2_MBUS_VIDEO_SOG_ACTIVE_LOW		(1 << 13)
 
 /* Serial flags */
 /* How many lanes the client can use */
-- 
1.7.9.5

