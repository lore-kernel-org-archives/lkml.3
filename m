Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932394Ab3BKUzl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:55:41 -0500
Received: from mail-ye0-f172.google.com ([209.85.213.172]:59689 "EHLO
	mail-ye0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932184Ab3BKUzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:55:40 -0500
From: Fabio Estevam <festevam@gmail.com>
To: sameo@linux.intel.com
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>
Subject: [PATCH 2/2] mfd: da9052-i2c: Staticize da9052_i2c_fix()
Date: Mon, 11 Feb 2013 18:48:01 -0200
Message-Id: <1360615681-19909-2-git-send-email-festevam@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360615681-19909-1-git-send-email-festevam@gmail.com>
References: <1360615681-19909-1-git-send-email-festevam@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabio Estevam <fabio.estevam@freescale.com>

da9052_i2c_fix() is only used locally, so let it be static.

Fix the following sparse warning:

drivers/mfd/da9052-i2c.c:63:5: warning: symbol 'da9052_i2c_fix' was not declared. Should it be static?

Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>
Signed-off-by: Fabio Estevam <fabio.estevam@freescale.com>
---
 drivers/mfd/da9052-i2c.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/mfd/da9052-i2c.c b/drivers/mfd/da9052-i2c.c
index 885e567..6a9fec4 100644
--- a/drivers/mfd/da9052-i2c.c
+++ b/drivers/mfd/da9052-i2c.c
@@ -60,7 +60,7 @@ static inline bool i2c_safe_reg(unsigned char reg)
  * This fix is to follow any read or write with a dummy read to a safe
  * register.
  */
-int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
+static int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
 {
 	int val;
 
@@ -85,7 +85,6 @@ int da9052_i2c_fix(struct da9052 *da9052, unsigned char reg)
 
 	return 0;
 }
-EXPORT_SYMBOL(da9052_i2c_fix);
 
 static int da9052_i2c_enable_multiwrite(struct da9052 *da9052)
 {
-- 
1.7.9.5

