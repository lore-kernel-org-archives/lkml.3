Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957AbaLCQI2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:08:28 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:45465 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752834AbaLCQIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:25 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-86-547f35777735
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Subject: [PATCH/RFC v9 11/19] v4l2-async: change custom.match callback argument
 type
Date: Wed, 03 Dec 2014 17:06:46 +0100
Message-id: <1417622814-10845-12-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrMLMWRmVeSWpSXmKPExsVy+t9jQd1y0/oQg/N3BS02zljPanF050Qm
	i/cb5zFZ9L9ZyGqx5OcuJotzr1YyWvRefc5ocbbpDbtF58Ql7BaXd81hs9j6Zh2jRc+GrawW
	S69fZLK4e+oom8WE6WtZLFr3HmG32L3rKavF4TftrBZn9q9kcxD2WDNvDaPHlN8bWT0u9/Uy
	eeycdZfd48PHOI+Vy7+weczumMnqcfjrQhaPTas62Tz2zP/B6tG3ZRWjx4rV39k9Pm+SC+CN
	4rJJSc3JLEst0rdL4MrYNvUeS8E6iYrun7NYGhiXi3QxcnJICJhI3Ps8mRXCFpO4cG89Wxcj
	F4eQwHRGiR9duxkhnHYmictHjjCBVLEJGEr8fPEayObgEBGIlrh0rB4kzCxwmVnixhYNEFtY
	IExizpMj7CA2i4CqxKu1bewg5bwCnhLvFqiDmBICChJzJtmAVHACRZ/+uA9WISTgIXFwov8E
	Rt4FjAyrGEVTC5ILipPSc430ihNzi0vz0vWS83M3MYKj4pn0DsZVDRaHGAU4GJV4eC3i6kKE
	WBPLiitzDzFKcDArifA++wYU4k1JrKxKLcqPLyrNSS0+xCjNwaIkznvjZm6IkEB6Yklqdmpq
	QWoRTJaJg1OqgdF7ipzMIf2KhQ9F9GIaZJeZHPXrl3942Mvyg6SUlr5rZJPgiepeg9xwn2OS
	35Mithxm28h8puZE3cZ2Ub0f/Ku14z6/j8pNPn/hyRydLxMqrX8zr61hyIpcVX5rbVL2wcu6
	V2eq/nxfk8d3UvKrw03+UMe1mx61TolWW2dxcNuD/dYvRfzL9JVYijMSDbWYi4oTAZ44+7+G	AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is useful to have an access to the async sub-device
being matched, not only to the related struct device.
Change match callback argument from struct device
to struct v4l2_subdev.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
---
 drivers/media/v4l2-core/v4l2-async.c |   16 ++++++++--------
 include/media/v4l2-async.h           |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-async.c b/drivers/media/v4l2-core/v4l2-async.c
index 85a6a34..8140992 100644
--- a/drivers/media/v4l2-core/v4l2-async.c
+++ b/drivers/media/v4l2-core/v4l2-async.c
@@ -22,10 +22,10 @@
 #include <media/v4l2-device.h>
 #include <media/v4l2-subdev.h>
 
-static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_i2c(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
 #if IS_ENABLED(CONFIG_I2C)
-	struct i2c_client *client = i2c_verify_client(dev);
+	struct i2c_client *client = i2c_verify_client(sd->dev);
 	return client &&
 		asd->match.i2c.adapter_id == client->adapter->nr &&
 		asd->match.i2c.address == client->addr;
@@ -34,14 +34,14 @@ static bool match_i2c(struct device *dev, struct v4l2_async_subdev *asd)
 #endif
 }
 
-static bool match_devname(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_devname(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return !strcmp(asd->match.device_name.name, dev_name(dev));
+	return !strcmp(asd->match.device_name.name, dev_name(sd->dev));
 }
 
-static bool match_of(struct device *dev, struct v4l2_async_subdev *asd)
+static bool match_of(struct v4l2_subdev *sd, struct v4l2_async_subdev *asd)
 {
-	return dev->of_node == asd->match.of.node;
+	return sd->dev->of_node == asd->match.of.node;
 }
 
 static LIST_HEAD(subdev_list);
@@ -52,7 +52,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 						    struct v4l2_subdev *sd)
 {
 	struct v4l2_async_subdev *asd;
-	bool (*match)(struct device *, struct v4l2_async_subdev *);
+	bool (*match)(struct v4l2_subdev *, struct v4l2_async_subdev *);
 
 	list_for_each_entry(asd, &notifier->waiting, list) {
 		/* bus_type has been verified valid before */
@@ -79,7 +79,7 @@ static struct v4l2_async_subdev *v4l2_async_belongs(struct v4l2_async_notifier *
 		}
 
 		/* match cannot be NULL here */
-		if (match(sd->dev, asd))
+		if (match(sd, asd))
 			return asd;
 	}
 
diff --git a/include/media/v4l2-async.h b/include/media/v4l2-async.h
index 7683569..1c0b586 100644
--- a/include/media/v4l2-async.h
+++ b/include/media/v4l2-async.h
@@ -51,7 +51,7 @@ struct v4l2_async_subdev {
 			unsigned short address;
 		} i2c;
 		struct {
-			bool (*match)(struct device *,
+			bool (*match)(struct v4l2_subdev *,
 				      struct v4l2_async_subdev *);
 			void *priv;
 		} custom;
-- 
1.7.9.5

