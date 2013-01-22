Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab3AVQwf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:52:35 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:54107 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754328Ab3AVQwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:52:18 -0500
From: Afzal Mohammed <afzal@ti.com>
To: <linux-fbdev@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Steffen Trumtrar <s.trumtrar@pengutronix.de>,
        Mike Turquette <mturquette@linaro.org>
Subject: [PATCH v3 01/12] video: da8xx-fb: make io operations safe
Date: Tue, 22 Jan 2013 22:22:03 +0530
Message-ID: <b2bf9cb1d1eda30d024cdd85d73c8f25c170b602.1358871750.git.afzal@ti.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <cover.1358871750.git.afzal@ti.com>
References: <cover.1358871750.git.afzal@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace __raw_readl/__raw_writel with readl/writel; this driver is
reused on ARMv7 (AM335x SoC).

Signed-off-by: Afzal Mohammed <afzal@ti.com>
---

v2: new patch

 drivers/video/da8xx-fb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/video/da8xx-fb.c b/drivers/video/da8xx-fb.c
index 720604c..35a33ca 100644
--- a/drivers/video/da8xx-fb.c
+++ b/drivers/video/da8xx-fb.c
@@ -141,12 +141,12 @@ static int frame_done_flag;
 
 static inline unsigned int lcdc_read(unsigned int addr)
 {
-	return (unsigned int)__raw_readl(da8xx_fb_reg_base + (addr));
+	return (unsigned int)readl(da8xx_fb_reg_base + (addr));
 }
 
 static inline void lcdc_write(unsigned int val, unsigned int addr)
 {
-	__raw_writel(val, da8xx_fb_reg_base + (addr));
+	writel(val, da8xx_fb_reg_base + (addr));
 }
 
 struct da8xx_fb_par {
-- 
1.7.12

