Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933012AbaGSRe7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 13:34:59 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:57820 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932400AbaGSRew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 13:34:52 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        LABBE Corentin <clabbe.montjoie@gmail.com>
Subject: [PATCH 2/4] staging: sep: No else is necessary after a break (reported by checkpatch)
Date: Sat, 19 Jul 2014 19:34:40 +0200
Message-Id: <1405791282-28023-3-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>
References: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: LABBE Corentin <clabbe.montjoie@gmail.com>
---
 drivers/staging/sep/sep_main.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/sep/sep_main.c b/drivers/staging/sep/sep_main.c
index 177e4b9..1580d95f 100644
--- a/drivers/staging/sep/sep_main.c
+++ b/drivers/staging/sep/sep_main.c
@@ -2881,12 +2881,11 @@ static int sep_free_dma_tables_and_dcb(struct sep_device *sep, bool isapplet,
 				if (is_kva) {
 					error = -ENODEV;
 					break;
-				} else {
-					error_temp = copy_to_user(
+				}
+				error_temp = copy_to_user(
 						(void __user *)tail_pt,
 						dcb_table_ptr->tail_data,
 						dcb_table_ptr->tail_data_size);
-				}
 				if (error_temp) {
 					/* Release the DMA resource */
 					error = -EFAULT;
-- 
1.8.5.5

