Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757964Ab3BEWMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:12:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48225 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754383Ab3BEWMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:12:31 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Bian Yu <bianyu@kedacom.com>, Jeff Garzik <jgarzik@redhat.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 77/93] [libata] ahci: Fix lack of command retry after a success error handler.
Date: Tue,  5 Feb 2013 20:07:06 -0200
Message-Id: <1360102042-10732-78-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bian Yu <bianyu@kedacom.com>

commit 1eaca39a84170b369fe61fb1da3c1e8606859e99 upstream.

It should be a mistake introduced by commit 8d899e70c1b3afff.

qc->flags can't be set AC_ERR_*

Signed-off-by: Bian Yu <bianyu@kedacom.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/ata/libata-eh.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 430a248..85fe5bc 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -2057,7 +2057,7 @@ static unsigned int ata_eh_speed_down(struct ata_device *dev,
  */
 static inline int ata_eh_worth_retry(struct ata_queued_cmd *qc)
 {
-	if (qc->flags & AC_ERR_MEDIA)
+	if (qc->err_mask & AC_ERR_MEDIA)
 		return 0;	/* don't retry media errors */
 	if (qc->flags & ATA_QCFLAG_IO)
 		return 1;	/* otherwise retry anything from fs stack */
-- 
1.7.9.5

