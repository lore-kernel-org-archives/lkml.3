Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499AbaIOWNb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:13:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50744 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932607AbaIOWN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:13:27 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 066/187] drm/tilcdc: fix release order on exit
Date: Mon, 15 Sep 2014 15:07:56 -0700
Message-Id: <1410818997-9432-67-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>

commit eb565a2bbadc6a5030a6dbe58db1aa52453e7edf upstream.

Unregister resources in the correct order on tilcdc_drm_fini, which is
the reverse order they were registered during tilcdc_drm_init.

This also means unregistering the driver before releasing its resources.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 247ab5d..af1b17a 100644
--- a/drivers/gpu/drm/tilcdc/tilcdc_drv.c
+++ b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
@@ -629,10 +629,10 @@ static int __init tilcdc_drm_init(void)
 static void __exit tilcdc_drm_fini(void)
 {
 	DBG("fini");
-	tilcdc_tfp410_fini();
-	tilcdc_slave_fini();
-	tilcdc_panel_fini();
 	platform_driver_unregister(&tilcdc_platform_driver);
+	tilcdc_panel_fini();
+	tilcdc_slave_fini();
+	tilcdc_tfp410_fini();
 }
 
 late_initcall(tilcdc_drm_init);
-- 
1.9.1

