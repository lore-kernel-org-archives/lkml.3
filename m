Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758516Ab3FAJ5g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:57:36 -0400
Received: from www17.your-server.de ([213.133.104.17]:60777 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab3FAJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:57:27 -0400
X-Greylist: delayed 367 seconds by postgrey-1.27 at vger.kernel.org; Sat, 01 Jun 2013 05:57:27 EDT
Message-ID: <1370080643.29224.32.camel@localhost.localdomain>
Subject: [PATCH] qeth: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:57:23 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Thomas Meyer <thomas@m3y3r.de>
---

diff -u -p a/drivers/s390/net/claw.c b/drivers/s390/net/claw.c
--- a/drivers/s390/net/claw.c
+++ b/drivers/s390/net/claw.c
@@ -3348,7 +3348,7 @@ static int __init claw_init(void)
 	}
 	CLAW_DBF_TEXT(2, setup, "init_mod");
 	claw_root_dev = root_device_register("claw");
-	ret = IS_ERR(claw_root_dev) ? PTR_ERR(claw_root_dev) : 0;
+	ret = PTR_RET(claw_root_dev);
 	if (ret)
 		goto register_err;
 	ret = ccw_driver_register(&claw_ccw_driver);
diff -u -p a/drivers/s390/net/ctcm_main.c b/drivers/s390/net/ctcm_main.c
--- a/drivers/s390/net/ctcm_main.c
+++ b/drivers/s390/net/ctcm_main.c
@@ -1837,7 +1837,7 @@ static int __init ctcm_init(void)
 	if (ret)
 		goto out_err;
 	ctcm_root_dev = root_device_register("ctcm");
-	ret = IS_ERR(ctcm_root_dev) ? PTR_ERR(ctcm_root_dev) : 0;
+	ret = PTR_RET(ctcm_root_dev);
 	if (ret)
 		goto register_err;
 	ret = ccw_driver_register(&ctcm_ccw_driver);
diff -u -p a/drivers/s390/net/lcs.c b/drivers/s390/net/lcs.c
--- a/drivers/s390/net/lcs.c
+++ b/drivers/s390/net/lcs.c
@@ -2441,7 +2441,7 @@ __init lcs_init_module(void)
 	if (rc)
 		goto out_err;
 	lcs_root_dev = root_device_register("lcs");
-	rc = IS_ERR(lcs_root_dev) ? PTR_ERR(lcs_root_dev) : 0;
+	rc = PTR_RET(lcs_root_dev);
 	if (rc)
 		goto register_err;
 	rc = ccw_driver_register(&lcs_ccw_driver);
diff -u -p a/drivers/s390/net/qeth_core_main.c b/drivers/s390/net/qeth_core_main.c
--- a/drivers/s390/net/qeth_core_main.c
+++ b/drivers/s390/net/qeth_core_main.c
@@ -5705,7 +5705,7 @@ static int __init qeth_core_init(void)
 	if (rc)
 		goto out_err;
 	qeth_core_root_dev = root_device_register("qeth");
-	rc = IS_ERR(qeth_core_root_dev) ? PTR_ERR(qeth_core_root_dev) : 0;
+	rc = PTR_RET(qeth_core_root_dev);
 	if (rc)
 		goto register_err;
 	qeth_core_header_cache = kmem_cache_create("qeth_hdr",


