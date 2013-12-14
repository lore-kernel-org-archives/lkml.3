Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3LNEnN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 23:43:13 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:34423 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942Ab3LNEnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 23:43:12 -0500
MIME-Version: 1.0
Date: Sat, 14 Dec 2013 12:43:11 +0800
Message-ID: <CAPgLHd_SQbatw9n57n-FPT1O3j4s_8YonjO8RwWCUscroh5jcw@mail.gmail.com>
Subject: [PATCH -next] ARM: pxa: fix return value check in em_x270_sensor_init()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: eric.y.miao@gmail.com, linux@arm.linux.org.uk, haojian.zhuang@gmail.com
Cc: yongjun_wei@trendmicro.com.cn, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

In case of error, the function regulator_get() returns ERR_PTR()
and never returns NULL. The NULL test in the return value check
should be replaced with IS_ERR().

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 arch/arm/mach-pxa/em-x270.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-pxa/em-x270.c b/arch/arm/mach-pxa/em-x270.c
index 6915a9f..339b422 100644
--- a/arch/arm/mach-pxa/em-x270.c
+++ b/arch/arm/mach-pxa/em-x270.c
@@ -971,9 +971,9 @@ static int em_x270_sensor_init(void)
 	gpio_direction_output(cam_reset, 0);
 
 	em_x270_camera_ldo = regulator_get(NULL, "vcc cam");
-	if (em_x270_camera_ldo == NULL) {
+	if (IS_ERR(em_x270_camera_ldo)) {
 		gpio_free(cam_reset);
-		return -ENODEV;
+		return PTR_ERR(em_x270_camera_ldo);
 	}
 
 	ret = regulator_enable(em_x270_camera_ldo);

