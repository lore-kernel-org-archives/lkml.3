Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394AbaJAHDG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:03:06 -0400
Received: from smtp73.ord1c.emailsrvr.com ([108.166.43.73]:32879 "EHLO
	smtp73.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751074AbaJAHDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:03:04 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
From: Pramod Gurav <pramod.gurav@smartplayin.com>
To: linux-kernel@vger.kernel.org
Cc: Pramod Gurav <pramod.gurav@smartplayin.com>, Michael Buesch <m@bues.ch>,
        netdev@vger.kernel.org
Subject: [PATCH] ssb: Fix Sparse error in main
Date: Wed,  1 Oct 2014 12:36:36 +0530
Message-Id: <1412147196-7466-1-git-send-email-pramod.gurav@smartplayin.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change fixes below sparse error:

drivers/ssb/main.c:94:16: warning: symbol 'ssb_sdio_func_to_bus'
was not declared. Should it be static?

Cc: Michael Buesch <m@bues.ch>
Cc: netdev@vger.kernel.org
Signed-off-by: Pramod Gurav <pramod.gurav@smartplayin.com>
---
 drivers/ssb/ssb_private.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ssb/ssb_private.h b/drivers/ssb/ssb_private.h
index eb507a5..86bbbe3 100644
--- a/drivers/ssb/ssb_private.h
+++ b/drivers/ssb/ssb_private.h
@@ -193,6 +193,7 @@ extern struct ssb_bus *ssb_pci_dev_to_bus(struct pci_dev *pdev);
 int ssb_for_each_bus_call(unsigned long data,
 			  int (*func)(struct ssb_bus *bus, unsigned long data));
 extern struct ssb_bus *ssb_pcmcia_dev_to_bus(struct pcmcia_device *pdev);
+struct ssb_bus *ssb_sdio_func_to_bus(struct sdio_func *func);
 
 struct ssb_freeze_context {
 	/* Pointer to the bus */
-- 
1.7.9.5

