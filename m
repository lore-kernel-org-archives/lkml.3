Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138AbaGKTmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 15:42:53 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37308 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294AbaGKTmw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 15:42:52 -0400
Date: Sat, 12 Jul 2014 01:12:43 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: linux-kernel@vger.kernel.org, Andreas Noever <andreas.noever@gmail.com>
Cc: julia.lawall@lip6.fr
Subject: [PATCH] thunderbolt: Use kcalloc
Message-ID: <20140711194243.GA3131@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The advantage of kcalloc is, that will prevent integer overflows
which could result from the multiplication of number of elements
and size and it is also a bit nicer to read.

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
A patch on top of my char-misc tree as the kzalloc version is
already applied there.

 drivers/thunderbolt/nhi.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/thunderbolt/nhi.c b/drivers/thunderbolt/nhi.c
index ce72f31..c68fe12 100644
--- a/drivers/thunderbolt/nhi.c
+++ b/drivers/thunderbolt/nhi.c
@@ -569,12 +569,10 @@ static int nhi_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			 nhi->hop_count);
 	INIT_WORK(&nhi->interrupt_work, nhi_interrupt_work);
 
-	nhi->tx_rings = devm_kzalloc(&pdev->dev,
-				     nhi->hop_count * sizeof(*nhi->tx_rings),
-				     GFP_KERNEL);
-	nhi->rx_rings = devm_kzalloc(&pdev->dev,
-				     nhi->hop_count * sizeof(*nhi->rx_rings),
-				     GFP_KERNEL);
+	nhi->tx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
+				     sizeof(*nhi->tx_rings), GFP_KERNEL);
+	nhi->rx_rings = devm_kcalloc(&pdev->dev, nhi->hop_count,
+				     sizeof(*nhi->rx_rings), GFP_KERNEL);
 	if (!nhi->tx_rings || !nhi->rx_rings)
 		return -ENOMEM;
 
-- 
1.9.1

