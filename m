Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621Ab3BSTRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 14:17:12 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:54170 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933860Ab3BSSu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:50:29 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 09/81] regulator: max8998: fix incorrect min_uV value for ldo10
Date: Tue, 19 Feb 2013 15:48:32 -0300
Message-Id: <1361299784-8830-10-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
References: <1361299784-8830-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.6 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Szyprowski <m.szyprowski@samsung.com>

commit 36a6f8c035760dcbd0c3acb4c2fd56268588a9cb upstream.

Correct value for minimal voltage for ldo10 output is 950000 uV. This
patch fixes the typo introduced by patch adf6178ad5552a7f2f742a8c85343c50
("regulator: max8998: Use uV in voltage_map_desc"), what solves broken
probe of max8998 in v3.8-rc4.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/regulator/max8998.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/max8998.c b/drivers/regulator/max8998.c
index b3b2984..b03c22d 100644
--- a/drivers/regulator/max8998.c
+++ b/drivers/regulator/max8998.c
@@ -65,7 +65,7 @@ static const struct voltage_map_desc ldo9_voltage_map_desc = {
 	.min = 2800000,	.step = 100000,	.max = 3100000,
 };
 static const struct voltage_map_desc ldo10_voltage_map_desc = {
-	.min = 95000,	.step = 50000,	.max = 1300000,
+	.min = 950000,	.step = 50000,	.max = 1300000,
 };
 static const struct voltage_map_desc ldo1213_voltage_map_desc = {
 	.min = 800000,	.step = 100000,	.max = 3300000,
-- 
1.7.9.5

