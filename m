Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752337AbaK3Lsb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2014 06:48:31 -0500
Received: from mail.sigma-star.at ([95.130.255.111]:14390 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752198AbaK3Lr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2014 06:47:57 -0500
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/6] UBI: Fastmap: Switch to ro mode if invalidate_fastmap() fails
Date: Sun, 30 Nov 2014 12:47:45 +0100
Message-Id: <1417348066-7043-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
In-Reply-To: <1417348066-7043-1-git-send-email-richard@nod.at>
References: <1417348066-7043-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to switch to ro mode to guarantee that upon next UBI attach
all data is consistent.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 8b95c48..3d913f5 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -1466,8 +1466,10 @@ err:
 	ret = 0;
 	if (old_fm) {
 		ret = invalidate_fastmap(ubi, old_fm);
-		if (ret < 0)
+		if (ret < 0) {
 			ubi_err(ubi, "Unable to invalidiate current fastmap!");
+			ubi_ro_mode(ubi);
+		}
 		else if (ret)
 			ret = 0;
 	}
-- 
1.8.4.5

