Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755260AbaIZJrA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 05:47:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33005 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755211AbaIZJqy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:54 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Guido=20Mart=C3=ADnez?= <guido@vanguardiasur.com.ar>,
        Dave Airlie <airlied@redhat.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 124/142] drm/tilcdc: fix release order on exit
Date: Fri, 26 Sep 2014 11:45:35 +0200
Message-Id: <a643641609ae76e8d1628ce72b40d826912f7b5a.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guido Martínez <guido@vanguardiasur.com.ar>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit eb565a2bbadc6a5030a6dbe58db1aa52453e7edf upstream.

Unregister resources in the correct order on tilcdc_drm_fini, which is
the reverse order they were registered during tilcdc_drm_init.

This also means unregistering the driver before releasing its resources.

Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
Tested-by: Darren Etheridge <detheridge@ti.com>
Signed-off-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/gpu/drm/tilcdc/tilcdc_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/tilcdc/tilcdc_drv.c b/drivers/gpu/drm/tilcdc/tilcdc_drv.c
index 247ab5d60df0..af1b17a0db66 100644
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
2.1.0

