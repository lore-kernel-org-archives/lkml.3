Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760252Ab3LBVhl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 16:37:41 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38149 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752962Ab3LBTGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 14:06:45 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jonathan Austin <jonathan.austin@arm.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Olof Johansson <olof@lixom.net>
Subject: [PATCH 3.4 02/60] ARM: integrator_cp: Set LCD{0,1} enable lines when turning on CLCD
Date: Mon,  2 Dec 2013 11:05:43 -0800
Message-Id: <20131202190330.740292588@linuxfoundation.org>
X-Mailer: git-send-email 1.8.4.3.gca3854a
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
References: <20131202190330.152596462@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Austin <jonathan.austin@arm.com>

commit 30aeadd44deea3f3b0df45b9a70ee0fd5f8d6dc2 upstream.

This turns on the internal integrator LCD display(s). It seems that the code
to do this got lost in refactoring of the CLCD driver.

Signed-off-by: Jonathan Austin <jonathan.austin@arm.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Olof Johansson <olof@lixom.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mach-integrator/integrator_cp.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/arm/mach-integrator/integrator_cp.c
+++ b/arch/arm/mach-integrator/integrator_cp.c
@@ -366,7 +366,8 @@ static AMBA_APB_DEVICE(aaci, "mb:1d", 0,
 static void cp_clcd_enable(struct clcd_fb *fb)
 {
 	struct fb_var_screeninfo *var = &fb->fb.var;
-	u32 val = CM_CTRL_STATIC1 | CM_CTRL_STATIC2;
+	u32 val = CM_CTRL_STATIC1 | CM_CTRL_STATIC2
+			| CM_CTRL_LCDEN0 | CM_CTRL_LCDEN1;
 
 	if (var->bits_per_pixel <= 8 ||
 	    (var->bits_per_pixel == 16 && var->green.length == 5))


