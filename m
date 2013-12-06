Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422921Ab3LFXSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:18:00 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48707 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758724Ab3LFXR5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:17:57 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jonathan Austin <jonathan.austin@arm.com>, Olof Johansson <olof@lixom.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 124/152] ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD
Date: Fri,  6 Dec 2013 15:10:48 -0800
Message-Id: <1386371476-2477-125-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Austin <jonathan.austin@arm.com>

commit 30aeadd44deea3f3b0df45b9a70ee0fd5f8d6dc2 upstream.

This turns on the internal integrator LCD display(s). It seems that the code
to do this got lost in refactoring of the CLCD driver.

Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/arm/mach-integrator/integrator_cp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm/mach-integrator/integrator_cp.c b/arch/arm/mach-integrator/integrator_cp.c
index 7322838..2314469 100644
--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -199,7 +199,8 @@ static struct mmci_platform_data mmc_data = {
 static void cp_clcd_enable(struct clcd_fb *fb)
 {
 	struct fb_var_screeninfo *var = &fb->fb.var;
-	u32 val = CM_CTRL_STATIC1 | CM_CTRL_STATIC2;
+	u32 val = CM_CTRL_STATIC1 | CM_CTRL_STATIC2
+			| CM_CTRL_LCDEN0 | CM_CTRL_LCDEN1;
 
 	if (var->bits_per_pixel <= 8 ||
 	    (var->bits_per_pixel == 16 && var->green.length == 5))
-- 
1.8.3.2

