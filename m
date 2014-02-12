Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751196AbaBLFKW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 00:10:22 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:37798 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872AbaBLFKV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 00:10:21 -0500
From: SeongJae Park <sj38.park@gmail.com>
To: lgirdwood@gmail.com, broonie@kernel.org, axel.lin@ingics.com
Cc: linux-kernel@vger.kernel.org, SeongJae Park <sj38.park@gmail.com>
Subject: [PATCH] regulator: da9055: declare return type of inline function exclusively
Date: Wed, 12 Feb 2014 14:11:07 +0900
Message-Id: <1392181867-16952-1-git-send-email-sj38.park@gmail.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

da9055_regulator_dt_init does not declare return type and it cause
following build warning.

drivers/regulator/da9055-regulator.c:582:15: warning:
        return type defaults to ‘int’ [-Wreturn-type]
 static inline da9055_regulator_dt_init(struct platform_device *pdev,
               ^

Fix the warning by declare return type as int exclusively.

Signed-off-by: SeongJae Park <sj38.park@gmail.com>
---
 drivers/regulator/da9055-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/da9055-regulator.c b/drivers/regulator/da9055-regulator.c
index 3b7a26c..cf74040 100644
--- a/drivers/regulator/da9055-regulator.c
+++ b/drivers/regulator/da9055-regulator.c
@@ -579,7 +579,7 @@ static int da9055_regulator_dt_init(struct platform_device *pdev,
 	return 0;
 }
 #else
-static inline da9055_regulator_dt_init(struct platform_device *pdev,
+static inline int da9055_regulator_dt_init(struct platform_device *pdev,
 				       struct da9055_regulator *regulator,
 				       struct regulator_config *config,
 				       int regid)
-- 
1.8.3.2

