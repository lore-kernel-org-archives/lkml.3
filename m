Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbaJ2MuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:50:06 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14400 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932946AbaJ2MqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:22 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 26/35] UBI: Fastmap: Set used_ebs only for static volumes
Date: Wed, 29 Oct 2014 13:45:49 +0100
Message-Id: <1414586758-9972-27-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we set it for dynamic ones we might confuse various self checks.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index af490c3..e563366 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -200,14 +200,15 @@ static struct ubi_ainf_volume *add_vol(struct ubi_attach_info *ai, int vol_id,
 	if (!av)
 		goto out;
 
-	av->highest_lnum = av->leb_count = 0;
+	av->highest_lnum = av->leb_count = av->used_ebs = 0;
 	av->vol_id = vol_id;
-	av->used_ebs = used_ebs;
 	av->data_pad = data_pad;
 	av->last_data_size = last_eb_bytes;
 	av->compat = 0;
 	av->vol_type = vol_type;
 	av->root = RB_ROOT;
+	if (av->vol_type == UBI_STATIC_VOLUME)
+		av->used_ebs = used_ebs;
 
 	dbg_bld("found volume (ID %i)", vol_id);
 
-- 
1.8.4.5

