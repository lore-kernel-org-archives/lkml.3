Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753444AbaCMIH4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 04:07:56 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:46834 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753368AbaCMIHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 04:07:16 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] power: bq24190: Remove empty OF device table
Date: Thu, 13 Mar 2014 09:07:11 +0100
Message-Id: <1394698031-1313-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.8.4.2
In-Reply-To: <1394698031-1313-1-git-send-email-thierry.reding@gmail.com>
References: <1394698031-1313-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

The driver already uses the of_match_ptr() macro that evaluates to NULL
when DT is disabled, so defining an empty device table is unnecessary.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/power/bq24190_charger.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/power/bq24190_charger.c b/drivers/power/bq24190_charger.c
index f5b21c0d0ba3..04403ce801c0 100644
--- a/drivers/power/bq24190_charger.c
+++ b/drivers/power/bq24190_charger.c
@@ -1517,10 +1517,6 @@ static const struct of_device_id bq24190_of_match[] = {
 	{ },
 };
 MODULE_DEVICE_TABLE(of, bq24190_of_match);
-#else
-static const struct of_device_id bq24190_of_match[] = {
-	{ },
-};
 #endif
 
 static struct i2c_driver bq24190_driver = {
-- 
1.8.4.2

