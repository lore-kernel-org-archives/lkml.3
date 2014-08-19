Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752158AbaHSL5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:57:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:28899 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751653AbaHSL5Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:57:16 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,893,1400050800"; 
   d="scan'208";a="586861102"
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Guenter Roeck <linux@roeck-us.net>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] watchdog: ts72xx_wdt: Kill superfluous variable in remove
Date: Tue, 19 Aug 2014 14:57:12 +0300
Message-Id: <1408449432-25274-1-git-send-email-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.1.0.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to store the return value of misc_deregister() in a
variable. Instead we can just return the value directly.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/watchdog/ts72xx_wdt.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/watchdog/ts72xx_wdt.c b/drivers/watchdog/ts72xx_wdt.c
index afa9d6ef353a..dee9c6cbe6df 100644
--- a/drivers/watchdog/ts72xx_wdt.c
+++ b/drivers/watchdog/ts72xx_wdt.c
@@ -428,11 +428,7 @@ static int ts72xx_wdt_probe(struct platform_device *pdev)
 
 static int ts72xx_wdt_remove(struct platform_device *pdev)
 {
-	int error;
-
-	error = misc_deregister(&ts72xx_wdt_miscdev);
-
-	return error;
+	return misc_deregister(&ts72xx_wdt_miscdev);
 }
 
 static struct platform_driver ts72xx_wdt_driver = {
-- 
2.1.0.rc1

