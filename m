Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759243AbaIOVLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:11:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54679 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754912AbaIOT0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:52 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        James Bottomley <JBottomley@Parallels.com>,
        poma <pomidorabelisima@gmail.com>,
        Vladimir Davydov <vdavydov@Parallels.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.16 046/158] scsi: use short driver name for per-driver cmd slab caches
Date: Mon, 15 Sep 2014 12:24:45 -0700
Message-Id: <20140915192544.281786505@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Bottomley <JBottomley@Parallels.com>

commit 884ffee01ddde5af260c7a5d1359c658aa1f0a11 upstream.

hostt->name might contain space, so use the ->proc_name short name instead
when creating per-driver command slabs.

Signed-off-by: James Bottomley <JBottomley@Parallels.com>
Reported-by: poma <pomidorabelisima@gmail.com>
Tested-by: poma <pomidorabelisima@gmail.com>
Reviewed-by: Vladimir Davydov <vdavydov@parallels.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/scsi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -368,8 +368,8 @@ scsi_alloc_host_cmd_pool(struct Scsi_Hos
 	if (!pool)
 		return NULL;
 
-	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->name);
-	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->name);
+	pool->cmd_name = kasprintf(GFP_KERNEL, "%s_cmd", hostt->proc_name);
+	pool->sense_name = kasprintf(GFP_KERNEL, "%s_sense", hostt->proc_name);
 	if (!pool->cmd_name || !pool->sense_name) {
 		scsi_free_host_cmd_pool(pool);
 		return NULL;


