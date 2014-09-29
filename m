Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755054AbaI2WVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 18:21:01 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14387 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaI2WU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 18:20:59 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 2/4] UBI: Fastmap: Calc fastmap size correctly
Date: Tue, 30 Sep 2014 00:20:46 +0200
Message-Id: <1412029248-22454-3-git-send-email-richard@nod.at>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1412029248-22454-1-git-send-email-richard@nod.at>
References: <1412029248-22454-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to add fm_sb too.

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index 0431b46..2b0d8d6 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -24,7 +24,8 @@ size_t ubi_calc_fm_size(struct ubi_device *ubi)
 {
 	size_t size;
 
-	size = sizeof(struct ubi_fm_hdr) + \
+	size = sizeof(struct ubi_fm_sb) + \
+		sizeof(struct ubi_fm_hdr) + \
 		sizeof(struct ubi_fm_scan_pool) + \
 		sizeof(struct ubi_fm_scan_pool) + \
 		(ubi->peb_count * sizeof(struct ubi_fm_ec)) + \
-- 
2.1.0

