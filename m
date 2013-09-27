Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753088Ab3I0Mwb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 08:52:31 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64049 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab3I0Mw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 08:52:27 -0400
From: Richard Genoud <richard.genoud@gmail.com>
To: Richard Weinberger <richard@nod.at>,
        Artem Bityutskiy <dedekind1@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        linux-kernel@vger.kernel.org,
        Richard Genoud <richard.genoud@gmail.com>
Subject: [PATCH] UBI: simplify image sequence test
Date: Fri, 27 Sep 2013 14:51:56 +0200
Message-Id: <1380286316-29911-2-git-send-email-richard.genoud@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1380286316-29911-1-git-send-email-richard.genoud@gmail.com>
References: <1380286316-29911-1-git-send-email-richard.genoud@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
---
 drivers/mtd/ubi/attach.c |    5 ++---
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
1.7.10.4

