Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760290AbbA2JSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 04:18:11 -0500
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:44911 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932477AbbA2JHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 04:07:46 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 087/176] scsi: blacklist RSOC for Microsoft iSCSI target devices
Date: Wed, 28 Jan 2015 15:28:37 +0100
Message-Id: <fd4e00fa8f869c3f71d5b704f0dc6532c923ebe5.1422455352.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
References: <ce4a451f616a1e7ab58cfeceea5e49c8b1c68c81.1422455352.git.jslaby@suse.cz>
In-Reply-To: <cover.1422455352.git.jslaby@suse.cz>
References: <cover.1422455352.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Martin K. Petersen" <martin.petersen@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 198a956a11b15b564ac06d1411881e215b587408 upstream.

The Microsoft iSCSI target does not support REPORT SUPPORTED OPERATION
CODES. Blacklist these devices so we don't attempt to send the command.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Mike Christie <michaelc@cs.wisc.edu>
Reported-by: jazz@deti74.ru
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.2.2

