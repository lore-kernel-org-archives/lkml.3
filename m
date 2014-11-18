Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753837AbaKRK6P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 05:58:15 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42683 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752006AbaKRK6L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 05:58:11 -0500
From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
To: Kukjin Kim <kgene.kim@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        LMML <linux-media@vger.kernel.org>
Cc: linux-samsung-soc@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Subject: [PATCH] media: exynos-gsc: fix build warning
Date: Tue, 18 Nov 2014 10:57:48 +0000
Message-Id: <1416308268-22957-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this patch fixes following build warning:

gsc-core.c:350:17: warning: 'low_plane' may be used uninitialized
gsc-core.c:371:31: warning: 'high_plane' may be used uninitialized

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 drivers/media/platform/exynos-gsc/gsc-core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/exynos-gsc/gsc-core.c b/drivers/media/platform/exynos-gsc/gsc-core.c
index 91d226b..6c71b17 100644
--- a/drivers/media/platform/exynos-gsc/gsc-core.c
+++ b/drivers/media/platform/exynos-gsc/gsc-core.c
@@ -347,8 +347,8 @@ void gsc_set_prefbuf(struct gsc_dev *gsc, struct gsc_frame *frm)
 		s_chk_addr = frm->addr.cb;
 		s_chk_len = frm->payload[1];
 	} else if (frm->fmt->num_planes == 3) {
-		u32 low_addr, low_plane, mid_addr, mid_plane;
-		u32 high_addr, high_plane;
+		u32 low_addr, low_plane = 0, mid_addr, mid_plane;
+		u32 high_addr, high_plane = 0;
 		u32 t_min, t_max;
 
 		t_min = min3(frm->addr.y, frm->addr.cb, frm->addr.cr);
-- 
1.9.1

