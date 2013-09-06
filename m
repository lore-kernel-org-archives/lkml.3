Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750889Ab3IFGjb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 02:39:31 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60530 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3IFGj3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 02:39:29 -0400
MIME-Version: 1.0
Date: Fri, 6 Sep 2013 14:39:28 +0800
Message-ID: <CAPgLHd8FyR_bdD75ETukz491+yDtOV7c4o2hmPbU0Y2L_3dm1g@mail.gmail.com>
Subject: [PATCH] VMCI: fix to pass correct device identity to free_irq()
From: Wei Yongjun <weiyj.lk@gmail.com>
To: acking@vmware.com, gregkh@linuxfoundation.org, dtor@vmware.com,
        georgezhang@vmware.com, asarwade@vmware.com
Cc: yongjun_wei@trendmicro.com.cn, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

free_irq() expects the same device identity that was passed to
corresponding request_irq(), otherwise the IRQ is not freed.

Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
---
 drivers/misc/vmw_vmci/vmci_guest.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/vmw_vmci/vmci_guest.c b/drivers/misc/vmw_vmci/vmci_guest.c
index b3a2b76..c98b03b 100644
--- a/drivers/misc/vmw_vmci/vmci_guest.c
+++ b/drivers/misc/vmw_vmci/vmci_guest.c
@@ -649,7 +649,7 @@ static int vmci_guest_probe_device(struct pci_dev *pdev,
 	return 0;
 
 err_free_irq:
-	free_irq(vmci_dev->irq, &vmci_dev);
+	free_irq(vmci_dev->irq, vmci_dev);
 	tasklet_kill(&vmci_dev->datagram_tasklet);
 	tasklet_kill(&vmci_dev->bm_tasklet);
 

