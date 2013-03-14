Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3CNV5F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:57:05 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:58391 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753284Ab3CNV5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:57:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Bill Pemberton <wfp5p@virginia.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: [PATCH 1/3] mfd: remove __exit_p annotation for twl4030_madc_remove
Date: Thu, 14 Mar 2013 22:56:38 +0100
Message-Id: <1363298204-8014-1-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.8.1.2
X-Provags-ID: V02:K0:qO5u7aNEQQuqylvRO48FGmTNjyPIellv97v9Lw+ZGA6
 hrlNtGyX6bPj5u2HEXJJGdLh9Mr2EmPPyfEebQ4/RABX++qEX6
 Z+GDYBsmelwr0iH1HbQQPSTr6rVID1QwfTy4JR83jfcFOfB8pT
 p2qtrjQl3B1t+YiOd+tnTHttnn8tjwCE0Eo68p/5lpab5i3dcg
 n0ycGivPjPLeP1rrVqYBftipXEOISUrI6PKU1UF86qT6/aB2K2
 /spfnyR/dAoX+24BvH41hfUOS3mvD1Wn/8Ewa9NmcmqXJEQlK+
 Q+ZvJfT7LHaUImeTwu2qojSKhfxqseyiHkC4NaIdAnADQY79xa
 nDaHHbGXeSJUWjc3dXD6kRzuwUjUJlwGXTwJIxzJq
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

4740f73fe5 "mfd: remove use of __devexit" removed the __devexit annotation
on the twl4030_madc_remove function, but left an __exit_p() present on the
pointer to this function. Using __exit_p was as wrong with the devexit in
place as it is now, but now we get a gcc warning about an unused function.

In order for the twl4030_madc_remove to work correctly in built-in code, we
have to remove the __exit_p.

Cc: Bill Pemberton <wfp5p@virginia.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---

Please apply to MFD tree for 3.9

 drivers/mfd/twl4030-madc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/twl4030-madc.c b/drivers/mfd/twl4030-madc.c
index 88ff9dc..942b666 100644
--- a/drivers/mfd/twl4030-madc.c
+++ b/drivers/mfd/twl4030-madc.c
@@ -800,7 +800,7 @@ static int twl4030_madc_remove(struct platform_device *pdev)
 
 static struct platform_driver twl4030_madc_driver = {
 	.probe = twl4030_madc_probe,
-	.remove = __exit_p(twl4030_madc_remove),
+	.remove = twl4030_madc_remove,
 	.driver = {
 		   .name = "twl4030_madc",
 		   .owner = THIS_MODULE,
-- 
1.8.1.2

