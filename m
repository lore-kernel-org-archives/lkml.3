Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaKGQ1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:27:23 -0500
Received: from down.free-electrons.com ([37.187.137.238]:60550 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752729AbaKGQ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:27:18 -0500
From: Boris Brezillon <boris.brezillon@free-electrons.com>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org, Sakari Ailus <sakari.ailus@iki.fi>
Cc: linux-arm-kernel@lists.infradead.org, linux-api@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
Subject: [PATCH v4 10/10] [media] v4l: Forbid usage of V4L2_MBUS_FMT definitions inside the kernel
Date: Fri,  7 Nov 2014 17:27:10 +0100
Message-Id: <1415377630-16564-1-git-send-email-boris.brezillon@free-electrons.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <545CDB8D.4080406@xs4all.nl>
References: <545CDB8D.4080406@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Place v4l2_mbus_pixelcode in a #ifndef __KERNEL__ section so that kernel
users don't have access to these definitions.

We have to keep this definition for user-space users even though they're
encouraged to move to the new media_bus_format enum.

Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
---
 include/uapi/linux/v4l2-mediabus.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/uapi/linux/v4l2-mediabus.h b/include/uapi/linux/v4l2-mediabus.h
index d712df8..3358e86 100644
--- a/include/uapi/linux/v4l2-mediabus.h
+++ b/include/uapi/linux/v4l2-mediabus.h
@@ -15,6 +15,17 @@
 #include <linux/types.h>
 #include <linux/videodev2.h>
 
+#ifndef __KERNEL__
+
+/*
+ * enum v4l2_mbus_pixelcode and its definitions are now deprecated, and
+ * MEDIA_BUS_FMT_ definitions (defined in media-bus-format.h) should be
+ * used instead.
+ *
+ * New defines should only be added to media-bus-format.h. The
+ * v4l2_mbus_pixelcode enum is frozen.
+ */
+
 #define V4L2_MBUS_FROM_MEDIA_BUS_FMT(name)	\
 	MEDIA_BUS_FMT_ ## name = V4L2_MBUS_FMT_ ## name
 
@@ -102,6 +113,7 @@ enum v4l2_mbus_pixelcode {
 
 	V4L2_MBUS_FROM_MEDIA_BUS_FMT(AHSV8888_1X32),
 };
+#endif /* __KERNEL__ */
 
 /**
  * struct v4l2_mbus_framefmt - frame format on the media bus
-- 
1.9.1

