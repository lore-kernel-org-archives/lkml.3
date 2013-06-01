Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616Ab3FAKAA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 06:00:00 -0400
Received: from www17.your-server.de ([213.133.104.17]:33226 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932561Ab3FAJ7q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:59:46 -0400
Message-ID: <1370080781.29224.39.camel@localhost.localdomain>
Subject: [PATCH] [SCSI] libsas: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: JBottomley@parallels.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:59:41 +0200
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

diff -u -p a/drivers/scsi/libsas/sas_scsi_host.c b/drivers/scsi/libsas/sas_scsi_host.c
--- a/drivers/scsi/libsas/sas_scsi_host.c
+++ b/drivers/scsi/libsas/sas_scsi_host.c
@@ -1093,9 +1093,7 @@ int sas_init_queue(struct sas_ha_struct
 
 	core->queue_thread = kthread_run(sas_queue_thread, sas_ha,
 					 "sas_queue_%d", core->shost->host_no);
-	if (IS_ERR(core->queue_thread))
-		return PTR_ERR(core->queue_thread);
-	return 0;
+	return PTR_RET(core->queue_thread);
 }
 
 void sas_shutdown_queue(struct sas_ha_struct *sas_ha)



