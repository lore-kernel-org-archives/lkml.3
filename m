Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335AbaJaTNX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 15:13:23 -0400
Received: from mezzanine.sirena.org.uk ([106.187.55.193]:59699 "EHLO
	mezzanine.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757544AbaJaTNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 15:13:19 -0400
From: Mark Brown <broonie@kernel.org>
To: Guenter Roeck <linux@roeck-us.net>, Liam Girdwood <lgirdwood@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mark Brown <broonie@kernel.org>
Date: Fri, 31 Oct 2014 19:12:41 +0000
Message-Id: <1414782761-15372-1-git-send-email-broonie@kernel.org>
X-Mailer: git-send-email 2.1.1
X-SA-Exim-Connect-IP: 94.175.94.161
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: [PATCH] regulator: Lower priorit of constraint logging
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on mezzanine.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems have very large numbers of regulators so the constraint
logging done at startup can end up being a very big part of the boot
output which is both verobse and slows things down if the console is
a serial console. Lower to dev_dbg() instead, we may want to provide
a boot parameter to raise this in future but for now people can edit
the source.

Signed-off-by: Mark Brown <broonie@kernel.org>
---
 drivers/regulator/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 55a87a2722d8..bbf93c9caca3 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -828,7 +828,7 @@ static void print_constraints(struct regulator_dev *rdev)
 	if (!count)
 		sprintf(buf, "no parameters");
 
-	rdev_info(rdev, "%s\n", buf);
+	rdev_dbg(rdev, "%s\n", buf);
 
 	if ((constraints->min_uV != constraints->max_uV) &&
 	    !(constraints->valid_ops_mask & REGULATOR_CHANGE_VOLTAGE))
-- 
2.1.1

