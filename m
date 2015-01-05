Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753538AbbAEJCD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 04:02:03 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:31848 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510AbbAEJBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 04:01:46 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-58-54aa52f656be
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Cc: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Subject: [PATCH 10/14] mfd: smsc-ece1099: Constify struct regmap_config
Date: Mon, 05 Jan 2015 10:01:29 +0100
Message-id: <1420448493-9355-10-git-send-email-k.kozlowski@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
References: <1420448493-9355-1-git-send-email-k.kozlowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNJMWRmVeSWpSXmKPExsVy+t/xa7rfglaFGOxbbGDx+oWhxf2vRxkt
	Lu+aw2ZxupvVgcXjzrU9bB7zTgZ69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bVKb8ZC56z
	Vuy+t5y1gfEtSxcjB4eEgInE4S/cXYycQKaYxIV769m6GLk4hASWMkosf/GBEcLpY5K4MWUT
	M0gVm4CxxOblS9hAbBGBLIkf01azgNjMAoYSP9/9YQexhQXcJebvuMEKYrMIqEo8m36UHWQZ
	L1B878MAiGVyEiePTWYFCXMChW8/jgQxhQTcJP69TZjAyLuAkWEVo2hqaXJBcVJ6rqFecWJu
	cWleul5yfu4mRkiAfNnBuPiY1SFGAQ5GJR5ejxMrQ4RYE8uKK3MPMUpwMCuJ8K67BRTiTUms
	rEotyo8vKs1JLT7EyMTBKdXA2D/lTabSnupZrMIHrLwOsX2TfCp5QImP5Wf5unkXff6y6TQ2
	hR95xcXAeFLVvtrdOWPhYaVdi//ua2Rh7zbffimgPOXt2vM166QPTMnnfC/XtNT5yBU/T1eu
	xKzCH+brO6YKdrE1alxrSqz70RJ8d3P/v7dx0/p2KXkY/K1dvOSvy6Jt5vl5SizFGYmGWsxF
	xYkAJHLKse4BAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The regmap_config struct may be const because it is not modified by the
driver and regmap_init() accepts pointer to const.

Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
---
 drivers/mfd/smsc-ece1099.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mfd/smsc-ece1099.c b/drivers/mfd/smsc-ece1099.c
index 90112d4cc905..03246880d484 100644
--- a/drivers/mfd/smsc-ece1099.c
+++ b/drivers/mfd/smsc-ece1099.c
@@ -24,7 +24,7 @@
 #include <linux/mfd/smsc.h>
 #include <linux/of_platform.h>
 
-static struct regmap_config smsc_regmap_config = {
+static const struct regmap_config smsc_regmap_config = {
 		.reg_bits = 8,
 		.val_bits = 8,
 		.max_register = SMSC_VEN_ID_H,
-- 
1.9.1

