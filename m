Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155Ab3IYUcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 16:32:18 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755481Ab3IYUcQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 16:32:16 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, richard.genoud@gmail.com,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] UBI: Fix error path in scan_pool()
Date: Wed, 25 Sep 2013 22:32:04 +0200
Message-Id: <1380141125-11063-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.1.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We have to set "ret", not "err" in case of an error.

Reported-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/fastmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mtd/ubi/fastmap.c b/drivers/mtd/ubi/fastmap.c
index f5aa4b0..9b42add 100644
--- a/drivers/mtd/ubi/fastmap.c
+++ b/drivers/mtd/ubi/fastmap.c
@@ -428,7 +428,7 @@ static int scan_pool(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		if (be32_to_cpu(ech->image_seq) != ubi->image_seq) {
 			ubi_err("bad image seq: 0x%x, expected: 0x%x",
 				be32_to_cpu(ech->image_seq), ubi->image_seq);
-			err = UBI_BAD_FASTMAP;
+			ret = UBI_BAD_FASTMAP;
 			goto out;
 		}
 
-- 
1.8.1.4

