Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576AbaIVIpr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 04:45:47 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753312AbaIVIpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 04:45:44 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/3] UBI: ubi_eba_read_leb: Remove in vain variable assignment
Date: Mon, 22 Sep 2014 10:45:34 +0200
Message-Id: <1411375536-20067-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to set err, it will be overwritten in any case
later at:
        if (scrub)
                err = ubi_wl_scrub_peb(ubi, pnum);

Signed-off-by: Richard Weinberger <richard@nod.at>
---
 drivers/mtd/ubi/eba.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/ubi/eba.c b/drivers/mtd/ubi/eba.c
index 0e11671d..2402d3b 100644
--- a/drivers/mtd/ubi/eba.c
+++ b/drivers/mtd/ubi/eba.c
@@ -441,10 +441,9 @@ retry:
 
 	err = ubi_io_read_data(ubi, buf, pnum, offset, len);
 	if (err) {
-		if (err == UBI_IO_BITFLIPS) {
+		if (err == UBI_IO_BITFLIPS)
 			scrub = 1;
-			err = 0;
-		} else if (mtd_is_eccerr(err)) {
+		else if (mtd_is_eccerr(err)) {
 			if (vol->vol_type == UBI_DYNAMIC_VOLUME)
 				goto out_unlock;
 			scrub = 1;
-- 
1.8.4.5

