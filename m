Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaFWNnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:43:24 -0400
Received: from smtprelay0134.hostedemail.com ([216.40.44.134]:59451 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756173AbaFWNnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:43:21 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:800:960:968:973:982:988:989:1260:1345:1359:1437:1534:1540:1711:1714:1730:1747:1777:1792:2393:2559:2562:3138:3139:3140:3141:3142:3350:3865:3867:4419:5007:6261:9592:10004:10026:10848:11026:11473:11658:11914:12043:12114:12296:12438:12517:12519:12555:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beef59_915225048910f
X-Filterd-Recvd-Size: 1669
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 21/22] synclink_gt: Use pci_zalloc_consistent
Date: Mon, 23 Jun 2014 06:41:49 -0700
Message-Id: <f09f13b8b57b40311b1aa8fa19267f4fed14a850.1403530604.git.joe@perches.com>
X-Mailer: git-send-email 1.8.1.2.459.gbcd45b4.dirty
In-Reply-To: <cover.1403530604.git.joe@perches.com>
References: <cover.1403530604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the now unnecessary memset too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/tty/synclink_gt.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index c359a91..07ea71c 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -3387,12 +3387,11 @@ static int alloc_desc(struct slgt_info *info)
 	unsigned int pbufs;
 
 	/* allocate memory to hold descriptor lists */
-	info->bufs = pci_alloc_consistent(info->pdev, DESC_LIST_SIZE, &info->bufs_dma_addr);
+	info->bufs = pci_zalloc_consistent(info->pdev, DESC_LIST_SIZE,
+					   &info->bufs_dma_addr);
 	if (info->bufs == NULL)
 		return -ENOMEM;
 
-	memset(info->bufs, 0, DESC_LIST_SIZE);
-
 	info->rbufs = (struct slgt_desc*)info->bufs;
 	info->tbufs = ((struct slgt_desc*)info->bufs) + info->rbuf_count;
 
-- 
1.8.1.2.459.gbcd45b4.dirty

