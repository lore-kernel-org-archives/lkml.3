Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577Ab3EOMw4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 08:52:56 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:40035 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932490Ab3EOMwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 08:52:54 -0400
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
        Sakari Ailus <sakari.ailus@iki.fi>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH RFC] media: OF: add field-active and sync-on-green endpoint properties
Date: Wed, 15 May 2013 18:22:29 +0530
Message-Id: <1368622349-32185-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lad, Prabhakar <prabhakar.csengg@gmail.com>

This patch adds "field-active" and "sync-on-green" as part of
endpoint properties and also support to parse them in the parser.

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>
Cc: Sakari Ailus <sakari.ailus@iki.fi>
Cc: Grant Likely <grant.likely@secretlab.ca>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: devicetree-discuss@lists.ozlabs.org
Cc: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: davinci-linux-open-source@linux.davincidsp.com
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
 .../devicetree/bindings/media/video-interfaces.txt |    4 ++++
 drivers/media/v4l2-core/v4l2-of.c                  |    6 ++++++
 include/media/v4l2-mediabus.h                      |    2 ++
 3 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/Documentation/devicetree/bindings/media/video-interfaces.txt b/Documentation/devicetree/bindings/media/video-interfaces.txt
index e022d2d..6bf87d0 100644
--- a/Documentation/devicetree/bindings/media/video-interfaces.txt
+++ b/Documentation/devicetree/bindings/media/video-interfaces.txt
@@ -101,6 +101,10 @@ Optional endpoint properties
   array contains only one entry.
 - clock-noncontinuous: a boolean property to allow MIPI CSI-2 non-continuous
   clock mode.
+-field-active: a boolean property indicating active high filed ID output
+ polarity is inverted.
+-sync-on-green: a boolean property indicating to sync with the green signal in
+ RGB.
 
 
 Example
diff --git a/drivers/media/v4l2-core/v4l2-of.c b/drivers/media/v4l2-core/v4l2-of.c
index aa59639..1d59455 100644
--- a/drivers/media/v4l2-core/v4l2-of.c
+++ b/drivers/media/v4l2-core/v4l2-of.c
@@ -100,6 +100,12 @@ static void v4l2_of_parse_parallel_bus(const struct device_node *node,
 	if (!of_property_read_u32(node, "data-shift", &v))
 		bus->data_shift = v;
 
+	if (of_get_property(node, "field-active", &v))
+		flags |= V4L2_MBUS_FIELD_ACTIVE;
+
+	if (of_get_property(node, "sync-on-green", &v))
+		flags |= V4L2_MBUS_SOG;
+
 	bus->flags = flags;
 
 }
diff --git a/include/media/v4l2-mediabus.h b/include/media/v4l2-mediabus.h
index 83ae07e..b95553d 100644
--- a/include/media/v4l2-mediabus.h
+++ b/include/media/v4l2-mediabus.h
@@ -40,6 +40,8 @@
 #define V4L2_MBUS_FIELD_EVEN_HIGH		(1 << 10)
 /* FIELD = 1/0 - Field1 (odd)/Field2 (even) */
 #define V4L2_MBUS_FIELD_EVEN_LOW		(1 << 11)
+#define V4L2_MBUS_FIELD_ACTIVE			(1 << 12)
+#define V4L2_MBUS_SOG				(1 << 13)
 
 /* Serial flags */
 /* How many lanes the client can use */
-- 
1.7.4.1

