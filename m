Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932943AbaJ2MqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:46:21 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14396 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932806AbaJ2MqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:16 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 15/35] UBI: Fastmap: Enhance fastmap checking
Date: Wed, 29 Oct 2014 13:45:38 +0100
Message-Id: <1414586758-9972-16-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't update the fastmap upon detach if fastmap checking is enabled.
This is poor men's power cut testing feature. :-)

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/build.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/build.c b/drivers/mtd/ubi/build.c
index 941110d..3712f88 100644
--- a/drivers/mtd/ubi/build.c
+++ b/drivers/mtd/ubi/build.c
@@ -1110,8 +1110,11 @@ int ubi_detach_mtd_dev(int ubi_num, int anyway)
 	ubi_msg("detaching mtd%d from ubi%d", ubi->mtd->index, ubi_num);
 #ifdef CONFIG_MTD_UBI_FASTMAP
 	/* If we don't write a new fastmap at detach time we lose all
-	 * EC updates that have been made since the last written fastmap. */
-	ubi_update_fastmap(ubi);
+	 * EC updates that have been made since the last written fastmap.
+	 * In case of fastmap debugging we omit the update to simulate an
+	 * unclean shutdown. */
+	if (!ubi_dbg_chk_fastmap(ubi))
+		ubi_update_fastmap(ubi);
 #endif
 	/*
 	 * Before freeing anything, we have to stop the background thread to
-- 
1.8.4.5

