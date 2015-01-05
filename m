Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753710AbbAEJGH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:06:07 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31652 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753675AbbAEJF7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:05:59 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-ee-54aa53f5de5c
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 2/3] regulator: max8649: Constify struct regmap_config and
 regulator_ops
Date: Mon, 05 Jan 2015 10:05:47 +0100
Message-id: <1420448748-9810-1-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448659-9636-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrAJMWRmVeSWpSXmKPExsVy+t/xK7pfg1eFGGyYYmYx9eETNovXLwwt
	vl3pYLK4vGsOmwOLx85Zd9k9Nq3qZPPo27KK0ePzJrkAligum5TUnMyy1CJ9uwSujM0XvjMX
	zOOsmNu2jL2B8Sl7FyMHh4SAicTfq55djJxAppjEhXvr2boYuTiEBJYyStxa18YK4fQxSexd
	sJoVpIpNwFhi8/IlbCC2iECGxOZ5U8HizAKGEj/f/WEHsYUFoiQ2z9zABGKzCKhK3D+3ixnE
	5hVwk7h4fQYTxDY5iZPHJoP1cgq4S/zcewwsLgRUc+fKBeYJjLwLGBlWMYqmliYXFCel5xrq
	FSfmFpfmpesl5+duYoSEypcdjIuPWR1iFOBgVOLh9TixMkSINbGsuDL3EKMEB7OSCO+6W0Ah
	3pTEyqrUovz4otKc1OJDjEwcnFINjHYnxPOu9C0P/ucrLWLSwr92guPDj+mz1fvTHxgfeqmi
	9Llwncfp7eue9syY8Gp74GZ5Tq6/enu3BnXY1cq3m9qyLzx7fJX3gUWNCtnNhc5/Vb9teZhm
	JLDrAPfquRsvFyQfPSYQPveF85MCHtF1ioKCM/fwfEmyOZyyhH25rWfh88UH2Z9VpiuxFGck
	GmoxFxUnAgDcPqWN8wEAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const. Make struct
regulator_ops const as well.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/regulator/max8649.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/max8649.c b/drivers/regulator/max8649.c
index c8bddcc8f911..81229579ece9 100644
--- a/drivers/regulator/max8649.c
+++ b/drivers/regulator/max8649.c
@@ -115,7 +115,7 @@ static unsigned int max8649_get_mode(struct regulator_dev *rdev)
 	return REGULATOR_MODE_NORMAL;
 }
 
-static struct regulator_ops max8649_dcdc_ops = {
+static const struct regulator_ops max8649_dcdc_ops = {
 	.set_voltage_sel = regulator_set_voltage_sel_regmap,
 	.get_voltage_sel = regulator_get_voltage_sel_regmap,
 	.list_voltage	= regulator_list_voltage_linear,
@@ -143,7 +143,7 @@ static struct regulator_desc dcdc_desc = {
 	.enable_is_inverted = true,
 };
 
-static struct regmap_config max8649_regmap_config = {
+static const struct regmap_config max8649_regmap_config = {
 	.reg_bits = 8,
 	.val_bits = 8,
 };
-- 
1.9.1

