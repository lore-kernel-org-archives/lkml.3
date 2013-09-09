Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab3IILt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:49:56 -0400
Received: from gerard.telenet-ops.be ([195.130.132.48]:38521 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab3IILtd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:49:33 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Mark Brown <broonie@kernel.org>
Cc: linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH 1/2] regulator: da9063: Fix PTR_ERR/ERR_PTR mismatch
Date: Mon,  9 Sep 2013 13:49:26 +0200
Message-Id: <1378727367-8941-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If CONFIG_OF=n:

drivers/regulator/da9063-regulator.c: In function ‘da9063_parse_regulators_dt’:
drivers/regulator/da9063-regulator.c:712: warning: passing argument 1 of ‘PTR_ERR’ makes pointer from integer without a cast
drivers/regulator/da9063-regulator.c:712: warning: return makes pointer from integer without a cast

Use ERR_PTR() to encode an error code in a pointer.
PTR_ERR() is meant to decode an error code from a pointer.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/regulator/da9063-regulator.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9063-regulator.c b/drivers/regulator/da9063-regulator.c
index 1a78163..b9f2653 100644
--- a/drivers/regulator/da9063-regulator.c
+++ b/drivers/regulator/da9063-regulator.c
@@ -709,7 +709,7 @@ static struct da9063_regulators_pdata *da9063_parse_regulators_dt(
 		struct of_regulator_match **da9063_reg_matches)
 {
 	da9063_reg_matches = NULL;
-	return PTR_ERR(-ENODEV);
+	return ERR_PTR(-ENODEV);
 }
 #endif
 
-- 
1.7.9.5

