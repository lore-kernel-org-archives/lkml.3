Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754863AbaDSAPf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 20:15:35 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:60787 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754589AbaDSAOh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 20:14:37 -0400
X-Originating-IP: 76.119.93.133
From: Ryan Desfosses <ryan@desfo.org>
To: bhelgaas@google.com
Cc: trivial@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Ryan Desfosses <ryan@desfo.org>
Subject: [PATCH 3/8] htirq: moved EXPORT_SYMBOL so that it immediately followed its function/variable
Date: Fri, 18 Apr 2014 20:13:48 -0400
Message-Id: <1397866433-21119-4-git-send-email-ryan@desfo.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397866433-21119-1-git-send-email-ryan@desfo.org>
References: <1397866433-21119-1-git-send-email-ryan@desfo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change made to resolve following checkpatch message:
  WARNING: EXPORT_SYMBOL(foo); should immediately follow its function/variable
branch: Linux 3.15-rc1

Signed-off-by: Ryan Desfosses <ryan@desfo.org>
---
 drivers/pci/htirq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/htirq.c b/drivers/pci/htirq.c
index 6e373ea..776c2ef 100644
--- a/drivers/pci/htirq.c
+++ b/drivers/pci/htirq.c
@@ -136,6 +136,7 @@ int __ht_create_irq(struct pci_dev *dev, int idx, ht_irq_update_t *update)
 
 	return irq;
 }
+EXPORT_SYMBOL(__ht_create_irq);
 
 /**
  * ht_create_irq - create an irq and attach it to a device.
@@ -151,6 +152,7 @@ int ht_create_irq(struct pci_dev *dev, int idx)
 {
 	return __ht_create_irq(dev, idx, NULL);
 }
+EXPORT_SYMBOL(ht_create_irq);
 
 /**
  * ht_destroy_irq - destroy an irq created with ht_create_irq
@@ -170,7 +172,5 @@ void ht_destroy_irq(unsigned int irq)
 
 	kfree(cfg);
 }
-
-EXPORT_SYMBOL(__ht_create_irq);
-EXPORT_SYMBOL(ht_create_irq);
 EXPORT_SYMBOL(ht_destroy_irq);
+
-- 
1.9.1

