Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab3FAJyN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:54:13 -0400
Received: from www17.your-server.de ([213.133.104.17]:60378 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566Ab3FAJyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:54:07 -0400
Message-ID: <1370080441.29224.27.camel@localhost.localdomain>
Subject: [PATCH] pnpbios: Cocci spatch "ptr_ret.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: rafael.j.wysocki@intel.com, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:54:01 +0200
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

diff -u -p a/drivers/pnp/pnpbios/core.c b/drivers/pnp/pnpbios/core.c
--- a/drivers/pnp/pnpbios/core.c
+++ b/drivers/pnp/pnpbios/core.c
@@ -572,10 +572,7 @@ static int __init pnpbios_thread_init(vo
 
 	init_completion(&unload_sem);
 	task = kthread_run(pnp_dock_thread, NULL, "kpnpbiosd");
-	if (IS_ERR(task))
-		return PTR_ERR(task);
-
-	return 0;
+	return PTR_RET(task);
 }
 
 /* Start the kernel thread later: */


