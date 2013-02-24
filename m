Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab3BXL4E (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 06:56:04 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:42141
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754807Ab3BXLzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 06:55:46 -0500
X-IronPort-AV: E=Sophos;i="4.84,727,1355094000"; 
   d="scan'208";a="3271403"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: kernel-janitors@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] drivers/regulator/s5m8767.c: adjust duplicate test
Date: Sun, 24 Feb 2013 12:55:34 +0100
Message-Id: <1361706934-15434-3-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1361706934-15434-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1361706934-15434-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Delete successive tests to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@s exists@
local idexpression y;
expression x,e;
@@

*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
... when != \(y = e\|y += e\|y -= e\|y |= e\|y &= e\|y++\|y--\|&y\)
*if ( \(x == NULL\|IS_ERR(x)\|y != 0\) )
 { ... when forall
   return ...; }
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/regulator/s5m8767.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 8a83194..8e56198 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -549,7 +549,7 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 
 	rmode = devm_kzalloc(&pdev->dev, sizeof(*rmode) *
 				pdata->num_regulators, GFP_KERNEL);
-	if (!rdata) {
+	if (!rmode) {
 		dev_err(iodev->dev,
 			"could not allocate memory for regulator mode\n");
 		return -ENOMEM;

