Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932373Ab3FAJv0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:51:26 -0400
Received: from www17.your-server.de ([213.133.104.17]:60066 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754643Ab3FAJvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:51:20 -0400
Message-ID: <1370080273.29224.21.camel@localhost.localdomain>
Subject: [PATCH] s390/ap: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:51:13 +0200
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

diff -u -p a/drivers/s390/crypto/ap_bus.c b/drivers/s390/crypto/ap_bus.c
--- a/drivers/s390/crypto/ap_bus.c
+++ b/drivers/s390/crypto/ap_bus.c
@@ -1795,7 +1795,7 @@ static int ap_poll_thread_start(void)
 	mutex_lock(&ap_poll_thread_mutex);
 	if (!ap_poll_kthread) {
 		ap_poll_kthread = kthread_run(ap_poll_thread, NULL, "appoll");
-		rc = IS_ERR(ap_poll_kthread) ? PTR_ERR(ap_poll_kthread) : 0;
+		rc = PTR_RET(ap_poll_kthread);
 		if (rc)
 			ap_poll_kthread = NULL;
 	}
@@ -1904,7 +1904,7 @@ int __init ap_module_init(void)
 
 	/* Create /sys/devices/ap. */
 	ap_root_device = root_device_register("ap");
-	rc = IS_ERR(ap_root_device) ? PTR_ERR(ap_root_device) : 0;
+	rc = PTR_RET(ap_root_device);
 	if (rc)
 		goto out_bus;
 


