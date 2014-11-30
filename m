Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752595AbaK3MUF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 07:20:05 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14390 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbaK3MUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 07:20:00 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 6/6] UBI: Fastmap: Remove else after return.
Date: Sun, 30 Nov 2014 13:19:48 +0100
Message-Id: <1417349988-9238-7-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417349988-9238-1-git-send-email-richard@nod.at>
References: <1417349988-9238-1-git-send-email-richard@nod.at>
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
index c471753..7a72af2 100644
--- a/drivers/mtd/ubi/fastmap-wl.c
+++ b/drivers/mtd/ubi/fastmap-wl.c
@@ -260,10 +260,10 @@ static struct ubi_wl_entry *get_peb_for_wl(struct ubi_device *ubi)
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

