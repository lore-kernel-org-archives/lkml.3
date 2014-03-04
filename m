Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224AbaCDUyn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 15:54:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41298 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbaCDUES (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 15:04:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Pekon Gupta <pekon@ti.com>, Brian Norris <computersforpeace@gmail.com>
Subject: [PATCH 3.13 132/172] mtd: nand: omap: fix ecclayout->oobfree->length
Date: Tue,  4 Mar 2014 12:03:36 -0800
Message-Id: <20140304200303.929007201@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140304200259.626667112@linuxfoundation.org>
References: <20140304200259.626667112@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pekon Gupta <pekon@ti.com>

commit bb38eefb6858ce16b34716145b9597a5680aa54c upstream.

This patch excludes reserved-marker byte-position from oobfree->length
calculation. Thus all bytes from oobfree->offset till end of OOB are free.

Signed-off-by: Pekon Gupta <pekon@ti.com>
Signed-off-by: Brian Norris <computersforpeace@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/omap2.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/omap2.c
+++ b/drivers/mtd/nand/omap2.c
@@ -2000,9 +2000,8 @@ static int omap_nand_probe(struct platfo
 		goto return_error;
 	}
 
-	/* populate remaining ECC layout data */
-	ecclayout->oobfree->length = mtd->oobsize - (BADBLOCK_MARKER_LENGTH +
-							ecclayout->eccbytes);
+	/* all OOB bytes from oobfree->offset till end off OOB are free */
+	ecclayout->oobfree->length = mtd->oobsize - ecclayout->oobfree->offset;
 	/* check if NAND device's OOB is enough to store ECC signatures */
 	if (mtd->oobsize < (ecclayout->eccbytes + BADBLOCK_MARKER_LENGTH)) {
 		pr_err("not enough OOB bytes required = %d, available=%d\n",


