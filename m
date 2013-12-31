Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab3LaKvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Dec 2013 05:51:18 -0500
Received: from ni.piap.pl ([195.187.100.4]:44630 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab3LaKvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Dec 2013 05:51:17 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: lkml <linux-kernel@vger.kernel.org>, linux-arm-kernel@lists.infradead.org
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Christian Hohnstaedt <chohnstaedt@innominate.com>
Date: Tue, 31 Dec 2013 11:51:16 +0100
MIME-Version: 1.0
Message-ID: <m3d2kduwd7.fsf@t19.piap.pl>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: [ARM] Fix kernel compile error: drivers/crypto/ixp4xx_crypto.c.
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20131231 #7206063, check: 20131231 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

drivers/crypto/ixp4xx_crypto.c: In function 'ixp_module_init':
drivers/crypto/ixp4xx_crypto.c:1419:2: error: 'dev' undeclared (first use in this function)

Now builds. Not tested on real hw.

Signed-off-by: Krzysztof Hałasa <khalasa@piap.pl>

--- a/drivers/crypto/ixp4xx_crypto.c
+++ b/drivers/crypto/ixp4xx_crypto.c
@@ -1410,14 +1410,12 @@ static const struct platform_device_info ixp_dev_info __initdata = {
 static int __init ixp_module_init(void)
 {
 	int num = ARRAY_SIZE(ixp4xx_algos);
-	int i, err ;
+	int i, err;
 
 	pdev = platform_device_register_full(&ixp_dev_info);
 	if (IS_ERR(pdev))
 		return PTR_ERR(pdev);
 
-	dev = &pdev->dev;
-
 	spin_lock_init(&desc_lock);
 	spin_lock_init(&emerg_lock);
 

-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
