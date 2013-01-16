Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191Ab3APP7q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:59:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35795 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756979Ab3APP7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:59:42 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 036/222] regulator: wm831x: Set the new rather than old value for DVS VSEL
Date: Wed, 16 Jan 2013 13:53:56 -0200
Message-Id: <1358351822-7675-37-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@opensource.wolfsonmicro.com>

commit 13ae633cf729b0ecb677b75b04886ff8fada8fad upstream.

Reported-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/regulator/wm831x-dcdc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/wm831x-dcdc.c b/drivers/regulator/wm831x-dcdc.c
index 099da11..1792c46 100644
--- a/drivers/regulator/wm831x-dcdc.c
+++ b/drivers/regulator/wm831x-dcdc.c
@@ -296,7 +296,7 @@ static int wm831x_buckv_set_voltage(struct regulator_dev *rdev,
 	if (vsel > dcdc->dvs_vsel) {
 		ret = wm831x_set_bits(wm831x, dvs_reg,
 				      WM831X_DC1_DVS_VSEL_MASK,
-				      dcdc->dvs_vsel);
+				      vsel);
 		if (ret == 0)
 			dcdc->dvs_vsel = vsel;
 		else
-- 
1.7.9.5

