Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754785AbaCKLZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 07:25:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803AbaCKLZL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 07:25:11 -0400
From: Colin King <colin.king@canonical.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] regulator: da9063: fix assignment of da9063_reg_matches to NULL
Date: Tue, 11 Mar 2014 11:25:09 +0000
Message-Id: <1394537109-25162-1-git-send-email-colin.king@canonical.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

cppcheck detected an incorrect assignment:

 drivers/regulator/da9063-regulator.c:711]: (warning) Assignment
 of function parameter has no effect outside the function

the original code didn't do anything, instead, *da9063_reg_matches
needs to be set to NULL.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/regulator/da9063-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 91e99a2..d3ccd54 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -710,7 +710,7 @@ static struct da9063_regulators_pdata *da9063_parse_regulators_dt(
 		struct platform_device *pdev,
 		struct of_regulator_match **da9063_reg_matches)
 {
-	da9063_reg_matches = NULL;
+	*da9063_reg_matches = NULL;
 	return ERR_PTR(-ENODEV);
 }
 #endif
-- 
1.9.0

