Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933029AbaJ2Mq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 08:46:29 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933002AbaJ2Mq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 08:46:26 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        tlinder@codeaurora.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 34/35] UBI: Fastmap: Remove else after return.
Date: Wed, 29 Oct 2014 13:45:57 +0100
Message-Id: <1414586758-9972-35-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1414586758-9972-1-git-send-email-richard@nod.at>
References: <1414586758-9972-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

checkpatch.pl complains:
WARNING: else is not generally useful after a break or return

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap-wl.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/fastmap-wl.c b/drivers/mtd/ubi/fastmap-wl.c
index f7e7ff6..828ea04 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -253,10 +253,10 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
 			schedule_work(&ubi->fm_work);
 		}
 		return NULL;
-	} else {
-		pnum = pool->pebs[pool->used++];
-		return ubi->lookuptbl[pnum];
 	}
+
+	pnum = pool->pebs[pool->used++];
+	return ubi->lookuptbl[pnum];
 }
 
 /**
-- 
1.8.4.5

