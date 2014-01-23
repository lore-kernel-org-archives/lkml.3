Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424AbaAWVBf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 16:01:35 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:63229 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027AbaAWVAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 16:00:03 -0500
From: Andreas Noever <andreas.noever@gmail.com>
To: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bhelgaas@google.com
Cc: Andreas Noever <andreas.noever@gmail.com>
Subject: [PATCH 4/8] PCI: Use request_resource_conflict instead of insert_ for bus numbers.
Date: Thu, 23 Jan 2014 21:59:24 +0100
Message-Id: <1390510768-5652-5-git-send-email-andreas.noever@gmail.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
References: <1390510768-5652-1-git-send-email-andreas.noever@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a conflict happens during insert_resource_conflict and all conflicts
fit within the newly inserted resource then they will become children of
the new resource. This is almost certainly not what we want for bus
numbers.

Signed-off-by: Andreas Noever <andreas.noever@gmail.com>
---
 drivers/pci/probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index bed1934..fe6e10e 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1852,7 +1852,7 @@ int pci_bus_insert_busn_res(struct pci_bus *b, int bus, int bus_max)
 		res->flags |= IORESOURCE_PCI_FIXED;
 	}
 
-	conflict = insert_resource_conflict(parent_res, res);
+	conflict = request_resource_conflict(parent_res, res);
 
 	if (conflict)
 		dev_printk(KERN_DEBUG, &b->dev,
-- 
1.8.5.3

