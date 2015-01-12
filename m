Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755928AbbALSqh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 13:46:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58298 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755172AbbALSaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 13:30:35 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 176/216] scsi: blacklist RSOC for Microsoft iSCSI target devices
Date: Mon, 12 Jan 2015 18:29:14 +0000
Message-Id: <1421087394-2712-64-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
References: <1421085933-32536-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt4 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 198a956a11b15b564ac06d1411881e215b587408 upstream.

The Microsoft iSCSI target does not support REPORT SUPPORTED OPERATION
CODES. Blacklist these devices so we don't attempt to send the command.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Mike Christie <michaelc@cs.wisc.edu>
Reported-by: jazz@deti74.ru
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/scsi/scsi_devinfo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_devinfo.c b/drivers/scsi/scsi_devinfo.c
index c1d04d4d3c6c..262ab837a704 100644
--- a/drivers/scsi/scsi_devinfo.c
+++ b/drivers/scsi/scsi_devinfo.c
@@ -211,6 +211,7 @@ static struct {
 	{"Medion", "Flash XL  MMC/SD", "2.6D", BLIST_FORCELUN},
 	{"MegaRAID", "LD", NULL, BLIST_FORCELUN},
 	{"MICROP", "4110", NULL, BLIST_NOTQ},
+	{"MSFT", "Virtual HD", NULL, BLIST_NO_RSOC},
 	{"MYLEX", "DACARMRB", "*", BLIST_REPORTLUN2},
 	{"nCipher", "Fastness Crypto", NULL, BLIST_FORCELUN},
 	{"NAKAMICH", "MJ-4.8S", NULL, BLIST_FORCELUN | BLIST_SINGLELUN},
-- 
2.1.4

