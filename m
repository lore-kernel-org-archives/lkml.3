Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754506Ab3I1N4O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 09:56:14 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:62413 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410Ab3I1Nzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 09:55:31 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: richard.genoud@gmail.com, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Subject: [PATCH 5/7] UBI: simplify image sequence test
Date: Sat, 28 Sep 2013 15:55:14 +0200
Message-Id: <1380376516-30144-6-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1380376516-30144-1-git-send-email-richard@nod.at>
References: <1380376516-30144-1-git-send-email-richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Genoud <richard.genoud@gmail.com>

The test:
if (!a && b)
  a = b;
can be symplified in:
if (!a)
  a = b;

And there's no need to test if ubi->image_seq is not null, because if it is,
it is set to image_seq.
So, we just test if image_seq is not null.

Signed-off-by: Richard Genoud <richard.genoud@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/attach.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/attach.c b/drivers/mtd/ubi/attach.c
index 03b32b0..33bb1f2 100644
--- a/drivers/mtd/ubi/attach.c
+++ b/drivers/mtd/ubi/attach.c
@@ -900,10 +900,9 @@ static int scan_peb(struct ubi_device *ubi, struct ubi_attach_info *ai,
 		 * number.
 		 */
 		image_seq = be32_to_cpu(ech->image_seq);
-		if (!ubi->image_seq && image_seq)
+		if (!ubi->image_seq)
 			ubi->image_seq = image_seq;
-		if (ubi->image_seq && image_seq &&
-		    ubi->image_seq != image_seq) {
+		if (image_seq && ubi->image_seq != image_seq) {
 			ubi_err("bad image sequence number %d in PEB %d, expected %d",
 				image_seq, pnum, ubi->image_seq);
 			ubi_dump_ec_hdr(ech);
-- 
1.8.3.1

