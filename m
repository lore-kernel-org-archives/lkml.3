Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3FAJ6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:58:23 -0400
Received: from www17.your-server.de ([213.133.104.17]:60881 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab3FAJ6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:58:15 -0400
Message-ID: <1370080689.29224.33.camel@localhost.localdomain>
Subject: [PATCH] s390: Cocci spatch "ptr_ret.spatch" (2)
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:58:09 +0200
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

diff -u -p a/drivers/s390/char/sclp.c b/drivers/s390/char/sclp.c
--- a/drivers/s390/char/sclp.c
+++ b/drivers/s390/char/sclp.c
@@ -1097,7 +1097,7 @@ static __init int sclp_initcall(void)
 	if (rc)
 		return rc;
 	sclp_pdev = platform_device_register_simple("sclp", -1, NULL, 0);
-	rc = IS_ERR(sclp_pdev) ? PTR_ERR(sclp_pdev) : 0;
+	rc = PTR_RET(sclp_pdev);
 	if (rc)
 		goto fail_platform_driver_unregister;
 	rc = atomic_notifier_chain_register(&panic_notifier_list,
diff -u -p a/drivers/s390/char/sclp_cmd.c b/drivers/s390/char/sclp_cmd.c
--- a/drivers/s390/char/sclp_cmd.c
+++ b/drivers/s390/char/sclp_cmd.c
@@ -668,7 +668,7 @@ static int __init sclp_detect_standby_me
 	if (rc)
 		goto out;
 	sclp_pdev = platform_device_register_simple("sclp_mem", -1, NULL, 0);
-	rc = IS_ERR(sclp_pdev) ? PTR_ERR(sclp_pdev) : 0;
+	rc = PTR_RET(sclp_pdev);
 	if (rc)
 		goto out_driver;
 	sclp_add_standby_memory();
diff -u -p a/drivers/s390/char/tape_class.c b/drivers/s390/char/tape_class.c
--- a/drivers/s390/char/tape_class.c
+++ b/drivers/s390/char/tape_class.c
@@ -77,7 +77,7 @@ struct tape_class_device *register_tape_
 	tcd->class_device = device_create(tape_class, device,
 					  tcd->char_device->dev, NULL,
 					  "%s", tcd->device_name);
-	rc = IS_ERR(tcd->class_device) ? PTR_ERR(tcd->class_device) : 0;
+	rc = PTR_RET(tcd->class_device);
 	if (rc)
 		goto fail_with_cdev;
 	rc = sysfs_create_link(


