Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbbAIPZB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:25:01 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24608 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757855AbbAIPYz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:24:55 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-86-54aff2c52ef3
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v10 16/19] Documentation: leds: Add description of
 v4l2-flash sub-device
Date: Fri, 09 Jan 2015 16:23:06 +0100
Message-id: <1420816989-1808-17-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsVy+t9jQd2jn9aHGCxcYmqxccZ6VoujOycy
	Wcw/co7Vovfqc0aLs01v2C0u75rDZrH1zTpGi54NW1kt7p46ymaxe9dTVovDb9pZLc7sX8nm
	wOOxc9Zddo/DXxeyeOyZ/4PVo2/LKkaPFau/s3t83iQXwBbFZZOSmpNZllqkb5fAldH98BRb
	wUueilmH/rE3ML7j6mLk5JAQMJFY/XwSM4QtJnHh3nq2LkYuDiGB6YwSGzqOMEM47UwS297d
	YwGpYhMwlPj54jVTFyMHh4hAtMSlY/UgNcwCLxgl7k1+wAZSIywQJ3GicREjiM0ioCrRe7UR
	bAOvgIfEwt13WEF6JQQUJOZMsgExOYHCLb+dQEwhAXeJN1cNJzDyLmBkWMUomlqQXFCclJ5r
	pFecmFtcmpeul5yfu4kRHIzPpHcwrmqwOMQowMGoxMO7QW59iBBrYllxZe4hRgkOZiUR3obN
	QCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8SvZtIUIC6YklqdmpqQWpRTBZJg5OqQZG3Z1R6rZ3
	ZjLGFLBfjLObOPmgaNF228kGR52fz62YO3NCdgqP77VDKw72SbhopvxYz+rt2GyqcuvQjINR
	5QnO8xjLSzrsXLYXuthkVN/dbTNZ8aCH9aL9rJM7XglbNQtc19We48kgm/P/4Izzm3adNrpv
	vlU6Mjgudd29VU3pO9PvaZ95+CZciaU4I9FQi7moOBEA8N+qKEICAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch extends LED Flash class documention by
the description of interactions with v4l2-flash sub-device.

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: Bryan Wu <cooloney@gmail.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
---
 Documentation/leds/leds-class-flash.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/leds/leds-class-flash.txt b/Documentation/leds/leds-class-flash.txt
index d80096b..2f38627 100644
--- a/Documentation/leds/leds-class-flash.txt
+++ b/Documentation/leds/leds-class-flash.txt
@@ -55,3 +55,16 @@ Following sysfs attributes are exposed for controlling flash led devices:
 			  upper limit
 
 		Flash faults are cleared, if possible, by reading the attribute.
+
+A LED subsystem driver can be controlled also from the level of VideoForLinux2
+subsystem. In order to enable this CONFIG_V4L2_FLASH_LED_CLASS symbol has to
+be defined in the kernel config. The driver must call the v4l2_flash_init
+function to get registered in the V4L2 subsystem. On remove the
+v4l2_flash_release function has to be called (see <media/v4l2-flash.h>).
+
+After proper initialization a V4L2 Flash sub-device is created. The sub-device
+exposes a number of V4L2 controls, which allow for controlling a LED Flash class
+device with use of its internal kernel API.
+Opening the V4L2 Flash sub-device makes the LED subsystem sysfs interface
+unavailable. The interface is re-enabled after the V4L2 Flash sub-device
+is closed.
-- 
1.7.9.5

