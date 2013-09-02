Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab3IBL2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 07:28:23 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:53412 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932192Ab3IBL2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 07:28:16 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: anton@enomsg.org, sachin.kamat@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 3/4] pm2301-charger: Check return value of regulator_enable
Date: Mon,  2 Sep 2013 16:40:24 +0530
Message-Id: <1378120226-24805-3-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
References: <1378120226-24805-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Check the return value of regulator_enable to silence the following
warning:
drivers/power/pm2301_charger.c:725:20: warning:
ignoring return value of ‘regulator_enable’, declared with
attribute warn_unused_result [-Wunused-result]

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Cc: Lee Jones <lee.jones@linaro.org>
---
 drivers/power/pm2301_charger.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/power/pm2301_charger.c b/drivers/power/pm2301_charger.c
index ffa10ed..ab87d1a 100644
--- a/drivers/power/pm2301_charger.c
+++ b/drivers/power/pm2301_charger.c
@@ -722,7 +722,12 @@ static int pm2xxx_charger_ac_en(struct ux500_charger *charger,
 
 		dev_dbg(pm2->dev, "Enable AC: %dmV %dmA\n", vset, iset);
 		if (!pm2->vddadc_en_ac) {
-			regulator_enable(pm2->regu);
+			ret = regulator_enable(pm2->regu);
+			if (ret) {
+				dev_err(pm2->dev,
+					"Failed to enable regulator\n");
+				goto error_occured;
+			}
 			pm2->vddadc_en_ac = true;
 		}
 
-- 
1.7.9.5

