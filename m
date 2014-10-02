Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaJBOTd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 10:19:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45625 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751448AbaJBOTc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 10:19:32 -0400
From: Lubomir Rintel <lkundrak@v3.sk>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org, Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, Lubomir Rintel <lkundrak@v3.sk>
Subject: [RESEND PATCH] saa7146: Create a device name before it's used
Date: Thu,  2 Oct 2014 16:19:15 +0200
Message-Id: <1412259555-19242-1-git-send-email-lkundrak@v3.sk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

request_irq() uses it, tries to create a procfs file with an empty name
otherwise.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=83771
Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
---
 drivers/media/common/saa7146/saa7146_core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/common/saa7146/saa7146_core.c b/drivers/media/common/saa7146/saa7146_core.c
index 97afee6..4418119 100644
--- a/drivers/media/common/saa7146/saa7146_core.c
+++ b/drivers/media/common/saa7146/saa7146_core.c
@@ -364,6 +364,9 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 		goto out;
 	}
 
+	/* create a nice device name */
+	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
+
 	DEB_EE("pci:%p\n", pci);
 
 	err = pci_enable_device(pci);
@@ -438,9 +441,6 @@ static int saa7146_init_one(struct pci_dev *pci, const struct pci_device_id *ent
 
 	/* the rest + print status message */
 
-	/* create a nice device name */
-	sprintf(dev->name, "saa7146 (%d)", saa7146_num);
-
 	pr_info("found saa7146 @ mem %p (revision %d, irq %d) (0x%04x,0x%04x)\n",
 		dev->mem, dev->revision, pci->irq,
 		pci->subsystem_vendor, pci->subsystem_device);
-- 
1.9.3

