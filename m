Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568Ab3BEOhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 09:37:05 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:48783 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab3BEOg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 09:36:59 -0500
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: qingx@marvell.com, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Cc: patches@linaro.org, Haojian Zhuang <haojian.zhuang@linaro.org>
Subject: [PATCH] backlight: max8925: clean build warning
Date: Tue,  5 Feb 2013 22:35:43 +0800
Message-Id: <1360074943-11436-1-git-send-email-haojian.zhuang@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <5110d184.0vSENeTH4nmtv7tl%fengguang.wu@intel.com>
References: <5110d184.0vSENeTH4nmtv7tl%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/video/backlight/max8925_bl.c: In function
‘max8925_backlight_probe’:
drivers/video/backlight/max8925_bl.c:177:3: warning: statement with no
effect [-Wunused-value]

Replace the macro definition by function.

Signed-off-by: Haojian Zhuang <haojian.zhuang@linaro.org>
---
 drivers/video/backlight/max8925_bl.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/max8925_bl.c b/drivers/video/backlight/max8925_bl.c
index 5ca11b0..d0714ad 100644
--- a/drivers/video/backlight/max8925_bl.c
+++ b/drivers/video/backlight/max8925_bl.c
@@ -121,7 +121,11 @@ static int max8925_backlight_dt_init(struct platform_device *pdev,
 	return 0;
 }
 #else
-#define max8925_backlight_dt_init(x, y)	(-1)
+static int max8925_backlight_dt_init(struct platform_device *pdev,
+			      struct max8925_backlight_pdata *pdata)
+{
+	return -1;
+}
 #endif
 
 static int max8925_backlight_probe(struct platform_device *pdev)
-- 
1.7.10.4

