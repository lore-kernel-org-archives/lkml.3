Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaEZPUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 11:20:46 -0400
Received: from isis.lip6.fr ([132.227.60.2]:57411 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927AbaEZPUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 11:20:43 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: linux-kernel@vger.kernel.org
Cc: benoit.taine@lip6.fr, kernel-janitors@vger.kernel.org
Subject: [PATCH 3/18] VMCI: Use kmemdup instead of kmalloc + memcpy
Date: Mon, 26 May 2014 17:21:11 +0200
Message-Id: <1401117687-28911-3-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
References: <1401117687-28911-1-git-send-email-benoit.taine@lip6.fr>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Mon, 26 May 2014 17:20:40 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This issue was reported by coccicheck using the semantic patch 
at scripts/coccinelle/api/memdup.cocci

Signed-off-by: Benoit Taine <benoit.taine@lip6.fr>
---
Tested by compilation without errors.

 drivers/misc/vmw_vmci/vmci_datagram.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/misc/vmw_vmci/vmci_datagram.c b/drivers/misc/vmw_vmci/vmci_datagram.c
index f3cdd90..d93b469 100644
--- a/drivers/misc/vmw_vmci/vmci_datagram.c
+++ b/drivers/misc/vmw_vmci/vmci_datagram.c
@@ -276,11 +276,10 @@ static int dg_dispatch_as_host(u32 context_id, struct vmci_datagram *dg)
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

