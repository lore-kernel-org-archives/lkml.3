Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbbAZPpb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 10:45:31 -0500
Received: from mail-we0-f175.google.com ([74.125.82.175]:61708 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbbAZPpJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 10:45:09 -0500
From: Kumar Amit Mehta <gmate.amit@gmail.com>
To: oleg.drokin@intel.com, andreas.dilger@intel.com
Cc: gregkh@linuxfoundation.org, srikrishanmalik@gmail.com, rd@radekdostal.com,
        tristan@lelong.xyz, HPDD-discuss@ml01.01.org,
        devel@driverdev.osuosl.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: lustre: lustre: mdc: lproc_mdc.c: Fix for potential NULL pointer dereference
Date: Mon, 26 Jan 2015 16:44:53 +0100
Message-Id: <1422287093-3241-1-git-send-email-gmate.amit@gmail.com>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mdc_kuc_write(), OBD_ALLOC(lh, len) may leave 'lh' to NULL as kmalloc
may fail to allocate memory. This fix adds a check to avoid, dereferencing
a NULL pointer.

Signed-off-by: Kumar Amit Mehta <gmate.amit@gmail.com>
---
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
index c420219..c791941 100644
--- a/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
+++ b/drivers/staging/lustre/lustre/mdc/lproc_mdc.c
@@ -106,6 +106,8 @@ static ssize_t mdc_kuc_write(struct file *file,
 		/* for mockup below */ 2 * cfs_size_round(sizeof(*hai));
 
 	OBD_ALLOC(lh, len);
+	if (!lh)
+		return -ENOMEM;
 
 	lh->kuc_magic = KUC_MAGIC;
 	lh->kuc_transport = KUC_TRANSPORT_HSM;
-- 
2.1.0

