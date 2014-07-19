Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932711AbaGSRew (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 13:34:52 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:49888 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932390AbaGSReu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 13:34:50 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 1/4] staging: sep: Solves some problems reported by checkpatch
Date: Sat, 19 Jul 2014 19:34:39 +0200
Message-Id: <1405791282-28023-2-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/staging/sep/sep_main.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 75ca15e..177e4b9 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -155,7 +155,7 @@ struct sep_queue_info *sep_queue_status_add(
 	unsigned long lck_flags;
 	struct sep_queue_info *my_elem = NULL;
 
-	my_elem = kzalloc(sizeof(struct sep_queue_info), GFP_KERNEL);
+	my_elem = kzalloc(sizeof(*my_elem), GFP_KERNEL);
 
 	if (!my_elem)
 		return NULL;
@@ -1006,8 +1006,8 @@ static int sep_crypto_dma(
 		return -ENOMEM;
 	}
 
-	sep_dma = kmalloc(sizeof(struct sep_dma_map) *
-		count_mapped, GFP_ATOMIC);
+	sep_dma = kmalloc_array(count_mapped, sizeof(struct sep_dma_map),
+			GFP_ATOMIC);
 
 	if (sep_dma == NULL) {
 		dev_dbg(&sep->pdev->dev, "Cannot allocate dma_maps\n");
@@ -1070,7 +1070,8 @@ static int sep_crypto_lli(
 
 	sep_map = *maps;
 
-	sep_lli = kmalloc(sizeof(struct sep_lli_entry) * nbr_ents, GFP_ATOMIC);
+	sep_lli = kmalloc_array(nbr_ents, sizeof(struct sep_lli_entry),
+			GFP_ATOMIC);
 
 	if (sep_lli == NULL) {
 		dev_dbg(&sep->pdev->dev, "Cannot allocate lli_maps\n");
@@ -3398,7 +3399,7 @@ static ssize_t sep_create_dcb_dmatables_context(struct sep_device *sep,
 	}
 
 	/* Allocate thread-specific memory for DCB */
-	*dcb_region = kzalloc(num_dcbs * sizeof(struct sep_dcblock),
+	*dcb_region = kcalloc(num_dcbs, sizeof(struct sep_dcblock),
 			      GFP_KERNEL);
 	if (!(*dcb_region)) {
 		error = -ENOMEM;
@@ -3480,7 +3481,7 @@ int sep_create_dcb_dmatables_context_kernel(struct sep_device *sep,
 		current->pid, num_dcbs);
 
 	/* Allocate thread-specific memory for DCB */
-	*dcb_region = kzalloc(num_dcbs * sizeof(struct sep_dcblock),
+	*dcb_region = kcalloc(num_dcbs, sizeof(struct sep_dcblock),
 			      GFP_KERNEL);
 	if (!(*dcb_region)) {
 		error = -ENOMEM;
@@ -4090,7 +4091,7 @@ static int sep_probe(struct pci_dev *pdev,
 	}
 
 	/* Allocate the sep_device structure for this device */
-	sep_dev = kzalloc(sizeof(struct sep_device), GFP_ATOMIC);
+	sep_dev = kzalloc(sizeof(*sep_dev), GFP_ATOMIC);
 	if (sep_dev == NULL) {
 		error = -ENOMEM;
 		goto end_function_disable_device;
-- 
1.8.5.5

