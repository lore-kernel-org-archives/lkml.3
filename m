Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753742AbaIXJpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 05:45:36 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:62803 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085AbaIXJpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 05:45:30 -0400
Message-ID: <1411551925.24415.0.camel@phoenix>
Subject: [PATCH] regulator: qcom_rpm: Don't explicitly initialise the first
 field of config
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 24 Sep 2014 17:45:25 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Doing so generates a warning as the first field is a pointer but we use
0 to initialize it.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 drivers/regulator/qcom_rpm-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom_rpm-regulator.c b/drivers/regulator/qcom_rpm-regulator.c
index 8f28309..8d5969a 100644
--- a/drivers/regulator/qcom_rpm-regulator.c
+++ b/drivers/regulator/qcom_rpm-regulator.c
@@ -631,7 +631,7 @@ static int rpm_reg_probe(struct platform_device *pdev)
 	struct regulator_init_data *initdata;
 	const struct qcom_rpm_reg *template;
 	const struct of_device_id *match;
-	struct regulator_config config = { 0 };
+	struct regulator_config config = { };
 	struct regulator_dev *rdev;
 	struct qcom_rpm_reg *vreg;
 	const char *key;
-- 
1.9.1



