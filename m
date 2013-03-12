Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab3CLFxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 01:53:06 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:57411 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab3CLFxD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 01:53:03 -0400
X-AuditID: cbfee691-b7f5f6d000002fda-31-513ec2bef479
From: Jingoo Han <jg1.han@samsung.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        "'Jingoo Han'" <jg1.han@samsung.com>
References: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
In-reply-to: <003e01ce1ee5$4897e020$d9c7a060$%han@samsung.com>
Subject: [PATCH 12/14] backlight: locomolcd: convert locomolcd to dev_pm_ops
Date: Tue, 12 Mar 2013 14:53:01 +0900
Message-id: <004901ce1ee5$db6ed160$924c7420$%han@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac4e5UhyF7eo33BPTaGekL6G0bVCBQAAIh9w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNIsWRmVeSWpSXmKPExsVy+t8zI919h+wCDRZtZLKYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDJ6p11j
	KbjAVzHr6j62BsYlPF2MnBwSAiYSt/csYoGwxSQu3FvPBmILCSxjlPg2zwum5tLOPUBxLqD4
	dEaJA2c2MkE4vxglOo48ZwSpYhNQk/jy5TB7FyMHh4iAvkRbiwZImFmgVGLrg/csEENtJe6u
	Bynn4OAUsJPY8jcLJCws4CNxau9edhCbRUBV4s/pU6wgNi9Q+ZMzP9ghbEGJH5PvsUCM1JJY
	v/M4E4QtL7F5zVtmkJESAuoSj/7qgoRFBIwkWm7cZYMoEZHY9+IdI8jFEgKX2CX+z93DBLFL
	QOLb5EMsEL2yEpsOMEO8KylxcMUNlgmMErOQbJ6FZPMsJJtnIVmxgJFlFaNoakFyQXFSepGp
	XnFibnFpXrpecn7uJkZIRE7cwXj/gPUhxmSg9ROZpUST84ERnVcSb2hsZmRhamJqbGRuaUaa
	sJI4r3qLdaCQQHpiSWp2ampBalF8UWlOavEhRiYOTqkGRjb+jxX5B/jm/Mo/sPrjyVcLE5ac
	1P1xJPOCwguxVgWZ9/mT+u+8dVladf32vJK8DM0FSwTPCO85tvLUvM5Tbf+sp0y9qrWf+bhG
	8P07s00zFrQs7ehw/Syx88atTTUdE28cbl4yaWG0hOV5vvv54hvOBiz48EJGQ7+UJffGY7k3
	89Z3uGQr3nVWYinOSDTUYi4qTgQAH5ypDd4CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJKsWRmVeSWpSXmKPExsVy+t9jQd29h+wCDc58sraYs34Nm8XlhZdY
	LS7vmsNmsXvXU1YHFo8TM36zeOyZ/4PVo2/LKkaPz5vkAliiGhhtMlITU1KLFFLzkvNTMvPS
	bZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4B2KimUJeaUAoUCEouLlfTtME0IDXHT
	tYBpjND1DQmC6zEyQAMJ6xgzeqddYym4wFcx6+o+tgbGJTxdjJwcEgImEpd27mGDsMUkLtxb
	D2RzcQgJTGeUOHBmIxOE84tRouPIc0aQKjYBNYkvXw6zdzFycIgI6Eu0tWiAhJkFSiW2PnjP
	AmILCdhK3F0PUs7BwSlgJ7HlbxZIWFjAR+LU3r3sIDaLgKrEn9OnWEFsXqDyJ2d+sEPYghI/
	Jt9jgRipJbF+53EmCFteYvOat8wgIyUE1CUe/dUFCYsIGEm03LjLBlEiIrHvxTvGCYxCs5BM
	moVk0iwkk2YhaVnAyLKKUTS1ILmgOCk910ivODG3uDQvXS85P3cTIzjin0nvYFzVYHGIUYCD
	UYmHV+GbbaAQa2JZcWXuIUYJDmYlEd6MzXaBQrwpiZVVqUX58UWlOanFhxiTgR6dyCwlmpwP
	TEZ5JfGGxiZmRpZGZhZGJubmpAkrifMebLUOFBJITyxJzU5NLUgtgtnCxMEp1cCYNuP+rXui
	xVd+7/vt9Njwm2b0N2ZeteZJE4RmB3/95P9txgqx6EivOaG/j3zac/bilcbf+3pOPFsTsPPe
	5PyWTR4WSV1T3A5k2SoX3Ux5pzC7onOHwO1JO+UahDm3TZl8jPWtp1ZG9bkqYQfrrur1kj23
	b366vVEh+1DoqtC+/r8W5hMYr1iZKrEUZyQaajEXFScCAJToz588AwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of using legacy suspend/resume methods, using newer dev_pm_ops
structure allows better control over power management.

Signed-off-by: Jingoo Han <jg1.han@samsung.com>
---
 drivers/video/backlight/locomolcd.c |   16 +++++++---------
 1 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/drivers/video/backlight/locomolcd.c b/drivers/video/backlight/locomolcd.c
index 146fea8..6c3ec42 100644
--- a/drivers/video/backlight/locomolcd.c
+++ b/drivers/video/backlight/locomolcd.c
@@ -157,25 +157,24 @@ static const struct backlight_ops locomobl_data = {
 	.update_status  = locomolcd_set_intensity,
 };
 
-#ifdef CONFIG_PM
-static int locomolcd_suspend(struct locomo_dev *dev, pm_message_t state)
+#ifdef CONFIG_PM_SLEEP
+static int locomolcd_suspend(struct device *dev)
 {
 	locomolcd_flags |= LOCOMOLCD_SUSPENDED;
 	locomolcd_set_intensity(locomolcd_bl_device);
 	return 0;
 }
 
-static int locomolcd_resume(struct locomo_dev *dev)
+static int locomolcd_resume(struct device *dev)
 {
 	locomolcd_flags &= ~LOCOMOLCD_SUSPENDED;
 	locomolcd_set_intensity(locomolcd_bl_device);
 	return 0;
 }
-#else
-#define locomolcd_suspend	NULL
-#define locomolcd_resume	NULL
 #endif
 
+static SIMPLE_DEV_PM_OPS(locomolcd_pm_ops, locomolcd_suspend, locomolcd_resume);
+
 static int locomolcd_probe(struct locomo_dev *ldev)
 {
 	struct backlight_properties props;
@@ -230,13 +229,12 @@ static int locomolcd_remove(struct locomo_dev *dev)
 
 static struct locomo_driver poodle_lcd_driver = {
 	.drv = {
-		.name = "locomo-backlight",
+		.name	= "locomo-backlight",
+		.pm	= &locomolcd_pm_ops,
 	},
 	.devid	= LOCOMO_DEVID_BACKLIGHT,
 	.probe	= locomolcd_probe,
 	.remove	= locomolcd_remove,
-	.suspend = locomolcd_suspend,
-	.resume = locomolcd_resume,
 };
 
 static int __init locomolcd_init(void)
-- 
1.7.2.5


