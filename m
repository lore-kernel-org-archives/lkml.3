Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751639AbbAQUki (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 15:40:38 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:45317 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751439AbbAQUkg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 15:40:36 -0500
Message-ID: <1421527234.2076.69.camel@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.19-rc4
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 17 Jan 2015 12:40:34 -0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is one fix for a Multiqueue sleeping in invalid context problem and
a MAINTAINER file update for Qlogic.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git scsi-fixes

The short changelog is:

Christoph Hellwig (1):
      scsi: ->queue_rq can't sleep

Nilesh Javali (1):
      MAINTAINERS: Update maintainer list for qla4xxx

And the diffstat:

 MAINTAINERS             | 3 +--
 drivers/scsi/scsi_lib.c | 3 +--
 2 files changed, 2 insertions(+), 4 deletions(-)

With full diff below.

James

---

diff --git a/MAINTAINERS b/MAINTAINERS
index ddb9ac8..f6dee56 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -7737,8 +7737,7 @@ F:	Documentation/scsi/LICENSE.qla2xxx
 F:	drivers/scsi/qla2xxx/
 
 QLOGIC QLA4XXX iSCSI DRIVER
-M:	Vikas Chaudhary <vikas.chaudhary@qlogic.com>
-M:	iscsi-driver@qlogic.com
+M:	QLogic-Storage-Upstream@qlogic.com
 L:	linux-scsi@vger.kernel.org
 S:	Supported
 F:	Documentation/scsi/LICENSE.qla4xxx
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ea95dd..6d5c0b8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -591,7 +591,6 @@ static void scsi_free_sgtable(struct scsi_data_buffer *sdb, bool mq)
 static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 {
 	struct scatterlist *first_chunk = NULL;
-	gfp_t gfp_mask = mq ? GFP_NOIO : GFP_ATOMIC;
 	int ret;
 
 	BUG_ON(!nents);
@@ -606,7 +605,7 @@ static int scsi_alloc_sgtable(struct scsi_data_buffer *sdb, int nents, bool mq)
 	}
 
 	ret = __sg_alloc_table(&sdb->table, nents, SCSI_MAX_SG_SEGMENTS,
-			       first_chunk, gfp_mask, scsi_sg_alloc);
+			       first_chunk, GFP_ATOMIC, scsi_sg_alloc);
 	if (unlikely(ret))
 		scsi_free_sgtable(sdb, mq);
 	return ret;


