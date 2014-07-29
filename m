Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754268AbaG2PV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:21:59 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:57251 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754081AbaG2PUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:20:00 -0400
X-IronPort-AV: E=Sophos;i="5.01,757,1400018400"; 
   d="scan'208";a="87459219"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Dario Ballabio <ballabio_dario@emc.com>
Cc: kernel-janitors@vger.kernel.org, linux-ia64@vger.kernel.org,
        ceph-devel@vger.kernel.org, toralf.foerster@gmx.de, hmh@hmh.eng.br,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 7/9] scsi: use correct structure type name in sizeof
Date: Tue, 29 Jul 2014 17:16:49 +0200
Message-Id: <1406647011-8543-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1406647011-8543-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Correct typo in the name of the type given to sizeof.  Because it is the
size of a pointer that is wanted, the typo has no impact on compilation or
execution.

This problem was found using Coccinelle (http://coccinelle.lip6.fr/).  The
semantic patch used can be found in message 0 of this patch series.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/u14-34f.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/u14-34f.c b/drivers/scsi/u14-34f.c
index 4e76fe8..617d72a 100644
--- a/drivers/scsi/u14-34f.c
+++ b/drivers/scsi/u14-34f.c
@@ -585,7 +585,7 @@ struct mscp {
    struct sg_list *sglist; /* pointer to the allocated SG list */
    };
 
-#define CP_TAIL_SIZE (sizeof(struct sglist *) + sizeof(dma_addr_t))
+#define CP_TAIL_SIZE (sizeof(struct sg_list *) + sizeof(dma_addr_t))
 
 struct hostdata {
    struct mscp cp[MAX_MAILBOXES];       /* Mailboxes for this board */

