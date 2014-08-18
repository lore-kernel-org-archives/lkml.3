Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaHRCe2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 22:34:28 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:34684 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbaHRCeN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 22:34:13 -0400
Message-ID: <1408329248.12083.2.camel@phoenix>
Subject: [PATCH] regulator: core: Fix build error due to const qualifier for
 ops
From: Axel Lin <axel.lin@ingics.com>
To: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>
Cc: Guodong Xu <guodong.xu@linaro.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 18 Aug 2014 10:34:08 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Drop const qualifier for ops of struct regulator_desc.
Allow regulator drivers to update ops before registering regulator.

Fix below build error:
  CC [M]  drivers/regulator/mc13892-regulator.o
drivers/regulator/mc13892-regulator.c: In function 'mc13892_regulator_probe':
drivers/regulator/mc13892-regulator.c:586:3: error: assignment of member 'set_mode' in read-only object
drivers/regulator/mc13892-regulator.c:588:3: error: assignment of member 'get_mode' in read-only object
make[2]: *** [drivers/regulator/mc13892-regulator.o] Error 1
make[1]: *** [drivers/regulator] Error 2
make: *** [drivers] Error 2

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Axel Lin <axel.lin@ingics.com>
---
 include/linux/regulator/driver.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/regulator/driver.h b/include/linux/regulator/driver.h
index efe058f..3abda75 100644
--- a/include/linux/regulator/driver.h
+++ b/include/linux/regulator/driver.h
@@ -246,7 +246,7 @@ struct regulator_desc {
 	int id;
 	bool continuous_voltage_range;
 	unsigned n_voltages;
-	const struct regulator_ops *ops;
+	struct regulator_ops *ops;
 	int irq;
 	enum regulator_type type;
 	struct module *owner;
-- 
1.9.1



