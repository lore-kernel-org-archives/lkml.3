Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaEWE1X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 00:27:23 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:45250 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaEWE0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 00:26:23 -0400
From: David Matlack <matlackdavid@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org, liodot@gmail.com,
        charrer@alacritech.com, David Matlack <matlackdavid@gmail.com>
Subject: [PATCH] staging: slicoss: remove private netdev list
Date: Thu, 22 May 2014 21:25:46 -0700
Message-Id: <1400819147-14236-7-git-send-email-matlackdavid@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
References: <1400819147-14236-1-git-send-email-matlackdavid@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the private linked list of netdev structs. This list isn't
being used anyway.

This patch has no noticable effect.

Signed-off-by: David Matlack <matlackdavid@gmail.com>
---
 drivers/staging/slicoss/slic.h    | 1 -
 drivers/staging/slicoss/slicoss.c | 4 ----
 2 files changed, 5 deletions(-)

diff --git a/drivers/staging/slicoss/slic.h b/drivers/staging/slicoss/slic.h
index 7de57c4..0dc73d5 100644
--- a/drivers/staging/slicoss/slic.h
+++ b/drivers/staging/slicoss/slic.h
@@ -407,7 +407,6 @@ struct adapter {
 	uint                card_size;
 	uint                chipid;
 	struct net_device  *netdev;
-	struct net_device  *next_netdevice;
 	struct slic_spinlock     adapter_lock;
 	struct slic_spinlock     reset_lock;
 	struct pci_dev     *pcidev;
diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index b8eeb3b..0165899 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -104,8 +104,6 @@ static char *slic_banner = "Alacritech SLIC Technology(tm) Server "
 
 static char *slic_proc_version = "2.0.351  2006/07/14 12:26:00";
 
-static struct net_device *head_netdevice;
-
 static struct base_driver slic_global = { {}, 0, 0, 0, 1, NULL, NULL };
 static int intagg_delay = 100;
 static u32 dynamic_intagg;
@@ -2993,8 +2991,6 @@ static void slic_init_adapter(struct net_device *netdev,
 	adapter->slic_regs = (__iomem struct slic_regs *)memaddr;
 	adapter->irq = pcidev->irq;
 /*	adapter->netdev = netdev;*/
-	adapter->next_netdevice = head_netdevice;
-	head_netdevice = netdev;
 	adapter->chipid = chip_idx;
 	adapter->port = 0;	/*adapter->functionnumber;*/
 	adapter->cardindex = adapter->port;
-- 
1.9.2

