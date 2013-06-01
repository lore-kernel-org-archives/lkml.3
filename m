Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758101Ab3FAJh0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Jun 2013 05:37:26 -0400
Received: from www17.your-server.de ([213.133.104.17]:58496 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754874Ab3FAJhR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Jun 2013 05:37:17 -0400
Message-ID: <1370079432.29224.2.camel@localhost.localdomain>
Subject: [PATCH] VMCI: Cocci spatch "memdup.spatch"
From: Thomas Meyer <thomas@m3y3r.de>
To: linux-kernel@vger.kernel.org
Date: Sat, 01 Jun 2013 11:37:12 +0200
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

diff -u -p a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -276,11 +276,10 @@ static int dg_dispatch_as_host(u32 conte
 		}
 
 		/* We make a copy to enqueue. */
-		new_dg = kmalloc(dg_size, GFP_KERNEL);
+		new_dg = kmemdup(dg, dg_size, GFP_KERNEL);
 		if (new_dg == NULL)
 			return VMCI_ERROR_NO_MEM;
 
-		memcpy(new_dg, dg, dg_size);
 		retval = vmci_ctx_enqueue_datagram(dg->dst.context, new_dg);
 		if (retval < VMCI_SUCCESS) {
 			kfree(new_dg);


