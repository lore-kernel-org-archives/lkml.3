Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaGFSeB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jul 2014 14:34:01 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:39804 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752162AbaGFSd7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jul 2014 14:33:59 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Jingoo Han <jg1.han@samsung.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Rob Clark <robdclark@gmail.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] video: fbdev: intelfb: intelfbhw.c:  Cleaning up variable that is never used
Date: Sun,  6 Jul 2014 20:35:14 +0200
Message-Id: <1404671714-18460-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Variable ar assigned a value that is never used.
I have also removed all the code that thereby serves no purpose.

This was found using a static code analysis program called cppcheck

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
---
 drivers/video/fbdev/intelfb/intelfbhw.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/video/fbdev/intelfb/intelfbhw.c b/drivers/video/fbdev/intelfb/intelfbhw.c
index fbad61d..dea89ed 100644
--- a/drivers/video/fbdev/intelfb/intelfbhw.c
+++ b/drivers/video/fbdev/intelfb/intelfbhw.c
@@ -937,15 +937,11 @@ static int calc_pll_params(int index, int clock, u32 *retm1, u32 *retm2,
 {
 	u32 m1, m2, n, p1, p2, n1, testm;
 	u32 f_vco, p, p_best = 0, m, f_out = 0;
-	u32 err_max, err_target, err_best = 10000000;
-	u32 n_best = 0, m_best = 0, f_best, f_err;
+	u32 err_best = 10000000;
+	u32 n_best = 0, m_best = 0, f_err;
 	u32 p_min, p_max, p_inc, div_max;
 	struct pll_min_max *pll = &plls[index];
 
-	/* Accept 0.5% difference, but aim for 0.1% */
-	err_max = 5 * clock / 1000;
-	err_target = clock / 1000;
-
 	DBG_MSG("Clock is %d\n", clock);
 
 	div_max = pll->max_vco / clock;
@@ -992,7 +988,6 @@ static int calc_pll_params(int index, int clock, u32 *retm1, u32 *retm2,
 					m_best = testm;
 					n_best = n;
 					p_best = p;
-					f_best = f_out;
 					err_best = f_err;
 				}
 			}
-- 
1.7.10.4

