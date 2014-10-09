Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777AbaJIHo3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:44:29 -0400
Received: from smtp113.ord1c.emailsrvr.com ([108.166.43.113]:37490 "EHLO
	smtp113.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750839AbaJIHoW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:44:22 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: broonie@kernel.org
Cc: linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 3/3] spi: qup: Remove .owner field for driver
Date: Thu,  9 Oct 2014 13:12:08 +0530
Message-Id: <1412840528-31508-1-git-send-email-kiran.padwal@smartplayin.com>
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
 drivers/spi/spi-qup.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/spi/spi-qup.c b/drivers/spi/spi-qup.c
index 97471e1..30511bd 100644
--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -758,7 +758,6 @@ static const struct dev_pm_ops spi_qup_dev_pm_ops = {
 static struct platform_driver spi_qup_driver = {
 	.driver = {
 		.name		= "spi_qup",
-		.owner		= THIS_MODULE,
 		.pm		= &spi_qup_dev_pm_ops,
 		.of_match_table = spi_qup_dt_match,
 	},
-- 
1.7.9.5

