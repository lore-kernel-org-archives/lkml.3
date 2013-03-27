Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755207Ab3C0Iuh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 04:50:37 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:56500 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754407Ab3C0Iqr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 04:46:47 -0400
From: Tony Prisk <linux@prisktech.co.nz>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: linux-fbdev@vger.kernel.org, florianschandinat@gmx.de,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>
Subject: [PATCH 5/6] video: vt8500: Adjust contrast in wm8505 framebuffer driver.
Date: Wed, 27 Mar 2013 21:47:00 +1300
Message-Id: <1364374021-10844-6-git-send-email-linux@prisktech.co.nz>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
References: <1364374021-10844-1-git-send-email-linux@prisktech.co.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The contrast value was typo'd on the original commit (0x80 instead of
0x08). Following feedback from an enduser, a value of 0x10 seems more
suitable due to the default backlight being <100%.

Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
---
 drivers/video/wm8505fb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index b94ebc9..5057457 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -373,7 +373,7 @@ static int wm8505fb_probe(struct platform_device *pdev)
 	fbi->fb.screen_base		= fb_mem_virt;
 	fbi->fb.screen_size		= fb_mem_len;
 
-	fbi->contrast = 0x80;
+	fbi->contrast = 0x10;
 	ret = wm8505fb_set_par(&fbi->fb);
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to set parameters\n");
-- 
1.7.9.5

