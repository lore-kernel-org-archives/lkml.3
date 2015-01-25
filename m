Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758474AbbAYSrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 13:47:20 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57551 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755761AbbAYSKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 13:10:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michaelc@cs.wisc.edu>, jazz@deti74.ru,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.18 083/183] scsi: blacklist RSOC for Microsoft iSCSI target devices
Date: Sun, 25 Jan 2015 10:06:45 -0800
Message-Id: <20150125180813.797503536@linuxfoundation.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <20150125180810.160428929@linuxfoundation.org>
References: <20150125180810.160428929@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Martin K. Petersen" <martin.petersen@oracle.com>

commit 198a956a11b15b564ac06d1411881e215b587408 upstream.

The Microsoft iSCSI target does not support REPORT SUPPORTED OPERATION
CODES. Blacklist these devices so we don't attempt to send the command.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Mike Christie <michaelc@cs.wisc.edu>
Reported-by: jazz@deti74.ru
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi_devinfo.c |    1 +
 1 file changed, 1 insertion(+)

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


