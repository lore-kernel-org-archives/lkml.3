Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932684AbbAIPYF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 10:24:05 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:24549 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979AbbAIPX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 10:23:59 -0500
X-AuditID: cbfee61b-f79d76d0000024d6-4e-54aff28d0c23
From: Jacek Anaszewski <j.anaszewski@samsung.com>
To: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, sakari.ailus@iki.fi, s.nawrocki@samsung.com,
        Jacek Anaszewski <j.anaszewski@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH/RFC v10 06/19] mfd: max77693: modifications around
 max77693_led_platform_data
Date: Fri, 09 Jan 2015 16:22:56 +0100
Message-id: <1420816989-1808-7-git-send-email-j.anaszewski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrLLMWRmVeSWpSXmKPExsVy+t9jQd3eT+tDDFYsUbfYOGM9q8XRnROZ
	LK5/ec5qMf/IOVaL3qvPGS3ONr1ht7j/9SijxeVdc9gstr5Zx2jRs2Erq8XdU0fZLHbvespq
	cfhNO6vFmf0r2Rz4PHbOusvucfjrQhaPO9f2sHnsmf+D1aNvyypGjxWrv7N7fN4kF8AexWWT
	kpqTWZZapG+XwJVx4ddXtoKl3BVN3z4yNjDO4+xi5OSQEDCRmLL+HyOELSZx4d56ti5GLg4h
	gemMEoceX2WBcNqZJJ79OMQOUsUmYCjx88Vrpi5GDg4RgWiJS8fqQcLMApuYJHZ91QWxhQXi
	JbbOWccKYrMIqEpMufsXrJVXwF3i/PseRpBWCQEFiTmTbEBMTgEPiZbfTiCmEFDFm6uGExh5
	FzAyrGIUTS1ILihOSs810itOzC0uzUvXS87P3cQIDtRn0jsYVzVYHGIU4GBU4uHdILc+RIg1
	say4MvcQowQHs5IIb8NmoBBvSmJlVWpRfnxRaU5q8SFGaQ4WJXFeJfu2ECGB9MSS1OzU1ILU
	IpgsEwenVAOjXVeAb3nZWo/EJonCV36Om1efjhHVU9A9Krpr9+/fW2btZJvGefnAGo+iRBlZ
	i4P1M69JP+vgV/uTHLT4u9KfjfJlngnaia/jFt2sPtFyUeFf35Hq+AOTS6ZdDu1nORJY+uTr
	07at97s2aAhLN/SEbXM3nHpjrZGPv8q+om3JW8/NWi9/QOS4EktxRqKhFnNRcSIAM/XCnVAC	AAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. Rename max77693_led_platform_data to max77693_led_config_data to
   avoid making impression that the led driver expects a board file -
   it relies on Device Tree data.
2. Remove fleds array, as the DT binding design has changed
3. Add "label" array for Device Tree strings with the name of a LED device
4. Make flash_timeout a two element array, for caching the sub-led
   related flash timeout.
5. Remove trigger array as the related data will not be provided
   in the DT binding

Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Chanwoo Choi <cw00.choi@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>
---
 include/linux/mfd/max77693.h |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/include/linux/mfd/max77693.h b/include/linux/mfd/max77693.h
index f0b6585..c1ccb13 100644
--- a/include/linux/mfd/max77693.h
+++ b/include/linux/mfd/max77693.h
@@ -87,17 +87,16 @@ enum max77693_led_boost_mode {
 	MAX77693_LED_BOOST_FIXED,
 };
 
-struct max77693_led_platform_data {
-	u32 fleds[2];
+struct max77693_led_config_data {
+	const char *label[2];
 	u32 iout_torch[2];
 	u32 iout_flash[2];
-	u32 trigger[2];
-	u32 trigger_type[2];
+	u32 flash_timeout[2];
 	u32 num_leds;
 	u32 boost_mode;
-	u32 flash_timeout;
 	u32 boost_vout;
 	u32 low_vsys;
+	u32 trigger_type;
 };
 
 /* MAX77693 */
-- 
1.7.9.5

