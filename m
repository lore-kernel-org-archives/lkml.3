Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536AbaJIHxM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:53:12 -0400
Received: from smtp81.ord1c.emailsrvr.com ([108.166.43.81]:34053 "EHLO
	smtp81.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750896AbaJIHw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:52:56 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: agross@codeaurora.org
Cc: galak@codeaurora.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 1/3] soc: qcom: Remove .owner field for driver
Date: Thu,  9 Oct 2014 13:20:47 +0530
Message-Id: <1412841047-31681-1-git-send-email-kiran.padwal@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to init .owner field.

Based on the patch from Peter Griffin <peter.griffin@linaro.org>
"mmc: remove .owner field for drivers using module_platform_driver"

This patch removes the superfluous .owner field for drivers which
use the module_platform_driver API, as this is overridden in
platform_driver_register anyway."

Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
---
 drivers/soc/qcom/qcom_gsbi.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/soc/qcom/qcom_gsbi.c b/drivers/soc/qcom/qcom_gsbi.c
index 447458e..17ac058 100644
--- a/drivers/soc/qcom/qcom_gsbi.c
+++ b/drivers/soc/qcom/qcom_gsbi.c
@@ -72,7 +72,6 @@ MODULE_DEVICE_TABLE(of, gsbi_dt_match);
 static struct platform_driver gsbi_driver = {
 	.driver = {
 		.name		= "gsbi",
-		.owner		= THIS_MODULE,
 		.of_match_table	= gsbi_dt_match,
 	},
 	.probe = gsbi_probe,
-- 
1.7.9.5

