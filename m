Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012AbaGFR0H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 13:26:07 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:35781 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979AbaGFR0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 13:26:05 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: xen-fbfront.c:  Cleaning up useless assignment of function parameter
Date: Sun,  6 Jul 2014 19:27:20 +0200
Message-Id: <1404667640-14855-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove assignment of function parameter, that has no effect outside the function

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/xen-fbfront.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/video/fbdev/xen-fbfront.c b/drivers/video/fbdev/xen-fbfront.c
index 901014b..e1207a1 100644
--- a/drivers/video/fbdev/xen-fbfront.c
+++ b/drivers/video/fbdev/xen-fbfront.c
@@ -222,7 +222,6 @@ static int xenfb_setcolreg(unsigned regno, unsigned red, unsigned green,
 	red = CNVT_TOHW(red, info->var.red.length);
 	green = CNVT_TOHW(green, info->var.green.length);
 	blue = CNVT_TOHW(blue, info->var.blue.length);
-	transp = CNVT_TOHW(transp, info->var.transp.length);
 #undef CNVT_TOHW
 
 	v = (red << info->var.red.offset) |
-- 
1.7.10.4

