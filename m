Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113AbaJIHlE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:41:04 -0400
Received: from smtp65.ord1c.emailsrvr.com ([108.166.43.65]:41810 "EHLO
	smtp65.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbaJIHkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:40:55 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
From: Kiran Padwal <kiran.padwal@smartplayin.com>
To: wsa@the-dreams.de, bjorn.andersson@sonymobile.com
Cc: agross@codeaurora.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Kiran Padwal <kiran.padwal@smartplayin.com>
Subject: [PATCH 2/3] i2c: qup: Remove .owner field for driver
Date: Thu,  9 Oct 2014 13:08:32 +0530
Message-Id: <1412840312-31402-1-git-send-email-kiran.padwal@smartplayin.com>
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
 drivers/i2c/busses/i2c-qup.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/i2c/busses/i2c-qup.c b/drivers/i2c/busses/i2c-qup.c
index 3a4d64e..f14af2e 100644
--- a/drivers/i2c/busses/i2c-qup.c
+++ b/drivers/i2c/busses/i2c-qup.c
@@ -760,7 +760,6 @@ static struct platform_driver qup_i2c_driver = {
 	.remove = qup_i2c_remove,
 	.driver = {
 		.name = "i2c_qup",
-		.owner = THIS_MODULE,
 		.pm = &qup_i2c_qup_pm_ops,
 		.of_match_table = qup_i2c_dt_match,
 	},
-- 
1.7.9.5

