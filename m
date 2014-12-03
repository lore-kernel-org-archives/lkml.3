Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185AbaLCQIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 11:08:54 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:26324 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaLCQIu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 11:08:50 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-a2-547f35901a76
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: kyungmin.park@samsung.com, b.zolnierkie@samsung.com, pavel@ucw.cz,
        cooloney@gmail.com, rpurdie@rpsys.net, sakari.ailus@iki.fi,
        s.nawrocki@samsung.com, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, Jacek Anaszewski <j.anaszewski@samsung.com>
Subject: [PATCH/RFC v9 15/19] Documentation: leds: Add description of
 v4l2-flash sub-device
Date: Wed, 03 Dec 2014 17:06:50 +0100
Message-id: <1417622814-10845-16-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jQd0JpvUhBrvPylhsnLGe1eLozolM
	Fv1vFrJanHu1ktGi9+pzRouzTW/YLS7vmsNmsfXNOkaLng1bWS2WXr/IZHH31FE2iwnT17JY
	tO49wm6xe9dTVovDb9pZLc7sX8nmIOCxZt4aRo/Lfb1MHjtn3WX3WLn8C5vH4a8LWTw2repk
	89gz/werR9+WVYweK1Z/Z/f4vEkugCuKyyYlNSezLLVI3y6BK+Pf881MBbd5KtqmTWRsYHzE
	1cXIySEhYCLx/dpVVghbTOLCvfVsXYxcHEIC0xklpu+ZxwrhtDNJXD/8gAWkik3AUOLni9dM
	XYwcHCIC0RKXjtWDhJkFDjJJ3HpcDmILC8RKzP94lgnEZhFQlfj35yEbiM0r4Cnxdu4ldpBW
	CQEFiTmTbEDCnEDhpz/ug4WFBDwkDk70n8DIu4CRYRWjaGpBckFxUnqukV5xYm5xaV66XnJ+
	7iZGcHA/k97BuKrB4hCjAAejEg+vRVxdiBBrYllxZe4hRgkOZiUR3mffgEK8KYmVValF+fFF
	pTmpxYcYpTlYlMR5b9zMDRESSE8sSc1OTS1ILYLJMnFwSjUwpq010zqyxndjvNSGx14/V7Uv
	l7KSMYt7VcN+KkwmusOFfW9IzfIf3lMPfTd5cybvu8Ytx7b2joNt03fcnWfsvVv/7YRzcx/q
	RdkXrjC4weyW6dx1cVVQ1ImcvpiDUTd5sieXpSzp6j6p+GNpHG/+iq0MnLd6TJ+s1FWc6vfj
	uVDn1CXcNxOFlViKMxINtZiLihMBlJY6B2oCAAA=
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
index 82e58b1..bc3855b 100644
--- a/Documentation/leds/leds-class-flash.txt
+++ b/Documentation/leds/leds-class-flash.txt
@@ -48,3 +48,16 @@ Following sysfs attributes are exposed for controlling flash led devices:
 			  upper limit
 
 		Flash faults are cleared by reading the attribute.
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

