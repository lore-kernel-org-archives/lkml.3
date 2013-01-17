Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758222Ab3AQB5w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 20:57:52 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:59016 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755928Ab3AQB5v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 20:57:51 -0500
Message-ID: <1358387866.17958.4.camel@phoenix>
Subject: [PATCH] regulator: lp8788-buck: Remove buck[1|2]_vout_addr array
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Milo Kim <milo.kim@ti.com>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-kernel@vger.kernel.org
Date: Thu, 17 Jan 2013 09:57:46 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The vout address for buck[1|2] can be easily calculated,
thus remote these arrays.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/lp8788-buck.c |   14 ++------------
 1 file changed, 2 insertions(+), 12 deletions(-)

diff --git a/drivers/regulator/lp8788-buck.c b/drivers/regulator/lp8788-buck.c
index ef845c7..97891a7 100644
--- a/drivers/regulator/lp8788-buck.c
+++ b/drivers/regulator/lp8788-buck.c
@@ -103,16 +103,6 @@ static const int lp8788_buck_vtbl[] = {
 	1950000, 2000000,
 };
 
-static const u8 buck1_vout_addr[] = {
-	LP8788_BUCK1_VOUT0, LP8788_BUCK1_VOUT1,
-	LP8788_BUCK1_VOUT2, LP8788_BUCK1_VOUT3,
-};
-
-static const u8 buck2_vout_addr[] = {
-	LP8788_BUCK2_VOUT0, LP8788_BUCK2_VOUT1,
-	LP8788_BUCK2_VOUT2, LP8788_BUCK2_VOUT3,
-};
-
 static void lp8788_buck1_set_dvs(struct lp8788_buck *buck)
 {
 	struct lp8788_buck1_dvs *dvs = (struct lp8788_buck1_dvs *)buck->dvs;
@@ -235,7 +225,7 @@ static u8 lp8788_select_buck_vout_addr(struct lp8788_buck *buck,
 			lp8788_read_byte(buck->lp, LP8788_BUCK_DVS_SEL, &val);
 			idx = (val & LP8788_BUCK1_DVS_M) >> LP8788_BUCK1_DVS_S;
 		}
-		addr = buck1_vout_addr[idx];
+		addr = LP8788_BUCK1_VOUT0 + idx;
 		break;
 	case BUCK2:
 		if (mode == EXTPIN) {
@@ -258,7 +248,7 @@ static u8 lp8788_select_buck_vout_addr(struct lp8788_buck *buck,
 			lp8788_read_byte(buck->lp, LP8788_BUCK_DVS_SEL, &val);
 			idx = (val & LP8788_BUCK2_DVS_M) >> LP8788_BUCK2_DVS_S;
 		}
-		addr = buck2_vout_addr[idx];
+		addr = LP8788_BUCK2_VOUT0 + idx;
 		break;
 	default:
 		goto err;
-- 
1.7.9.5



