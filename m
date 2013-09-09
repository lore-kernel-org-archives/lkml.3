Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3IIDJx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 23:09:53 -0400
Received: from top.free-electrons.com ([176.31.233.9]:52551 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751776Ab3IIDJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 23:09:52 -0400
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com
Cc: david.vrabel@citrix.com, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] xen: remove deprecated IRQF_DISABLED
Date: Mon,  9 Sep 2013 05:09:47 +0200
Message-Id: <1378696187-4359-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch proposes to remove the IRQF_DISABLED flag from drivers/xen
code. It's a NOOP since 2.6.35 and it will be removed one day.

Note that architecture dependent fixes for IRQF_DISABLED
were already submitted through separate patches.

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/xen/evtchn.c       | 2 +-
 drivers/xen/platform-pci.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/xen/evtchn.c b/drivers/xen/evtchn.c
index 8b3a69a..5de2063 100644
--- a/drivers/xen/evtchn.c
+++ b/drivers/xen/evtchn.c
@@ -305,7 +305,7 @@ static int evtchn_bind_to_user(struct per_user_data *u, int port)
 	if (rc < 0)
 		goto err;
 
-	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, IRQF_DISABLED,
+	rc = bind_evtchn_to_irqhandler(port, evtchn_interrupt, 0,
 				       u->name, evtchn);
 	if (rc < 0)
 		goto err;
diff --git a/drivers/xen/platform-pci.c b/drivers/xen/platform-pci.c
index 99db9e1..2f3528e 100644
--- a/drivers/xen/platform-pci.c
+++ b/drivers/xen/platform-pci.c
@@ -84,7 +84,7 @@ static irqreturn_t do_hvm_evtchn_intr(int irq, void *dev_id)
 static int xen_allocate_irq(struct pci_dev *pdev)
 {
 	return request_irq(pdev->irq, do_hvm_evtchn_intr,
-			IRQF_DISABLED | IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
+			IRQF_NOBALANCING | IRQF_TRIGGER_RISING,
 			"xen-platform-pci", pdev);
 }
 
-- 
1.8.1.2

