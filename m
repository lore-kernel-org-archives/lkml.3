Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbaDNWZ1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 18:25:27 -0400
Received: from mail-ig0-f178.google.com ([209.85.213.178]:36522 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751601AbaDNWZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 18:25:25 -0400
Subject: [PATCH] xen/pci: Remove unused dev_err() string
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Apr 2014 16:25:23 -0600
Message-ID: <20140414222523.15032.99127.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We previously verified that "action" is either BUS_NOTIFY_ADD_DEVICE or
BUS_NOTIFY_DEL_DEVICE, so there's no need for the default "?" case.

Found by Coverity (CID 146520).

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 drivers/xen/pci.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/xen/pci.c b/drivers/xen/pci.c
index dd9c249ea311..59a25f937bd7 100644
--- a/drivers/xen/pci.c
+++ b/drivers/xen/pci.c
@@ -177,8 +177,7 @@ static int xen_pci_notifier(struct notifier_block *nb,
 	}
 	if (r)
 		dev_err(dev, "Failed to %s - passthrough or MSI/MSI-X might fail!\n",
-			action == BUS_NOTIFY_ADD_DEVICE ? "add" :
-			(action == BUS_NOTIFY_DEL_DEVICE ? "delete" : "?"));
+			action == BUS_NOTIFY_ADD_DEVICE ? "add" : "del");
 	return NOTIFY_OK;
 }
 

