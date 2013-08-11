Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754682Ab3HKQy7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 12:54:59 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:38019
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754442Ab3HKQwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 12:52:07 -0400
X-IronPort-AV: E=Sophos;i="4.89,857,1367964000"; 
   d="scan'208";a="23717952"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Sergey Lapin <slapin@ossfans.org>
Cc: kernel-janitors@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 8/16] arch/arm/mach-pxa/palmz72.c: Avoid using ARRAY_AND_SIZE(e) as a function argument
Date: Sun, 11 Aug 2013 18:51:49 +0200
Message-Id: <1376239917-15594-9-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376239917-15594-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Replace ARRAY_AND_SIZE(e) in function argument position to avoid hiding the
arity of the called function.

The semantic match that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e,f;
@@

f(...,
- ARRAY_AND_SIZE(e)
+ e,ARRAY_SIZE(e)
  ,...)
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
Not compiled.

 arch/arm/mach-pxa/palmz72.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/arch/arm/mach-pxa/palmz72.c b/arch/arm/mach-pxa/palmz72.c
index 1a35ddf..5f8fd00 100644
--- a/arch/arm/mach-pxa/palmz72.c
+++ b/arch/arm/mach-pxa/palmz72.c
@@ -356,9 +356,11 @@ static inline void __init palmz72_cam_gpio_init(void)
 {
 	int ret;
 
-	ret = gpio_request_array(ARRAY_AND_SIZE(palmz72_camera_gpios));
+	ret = gpio_request_array(palmz72_camera_gpios,
+				 ARRAY_SIZE(palmz72_camera_gpios));
 	if (!ret)
-		gpio_free_array(ARRAY_AND_SIZE(palmz72_camera_gpios));
+		gpio_free_array(palmz72_camera_gpios,
+				ARRAY_SIZE(palmz72_camera_gpios));
 	else
 		printk(KERN_ERR "Camera GPIO init failed!\n");
 
@@ -381,7 +383,7 @@ static inline void palmz72_camera_init(void) {}
  ******************************************************************************/
 static void __init palmz72_init(void)
 {
-	pxa2xx_mfp_config(ARRAY_AND_SIZE(palmz72_pin_config));
+	pxa2xx_mfp_config(palmz72_pin_config, ARRAY_SIZE(palmz72_pin_config));
 	pxa_set_ffuart_info(NULL);
 	pxa_set_btuart_info(NULL);
 	pxa_set_stuart_info(NULL);

