Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932442AbaAWSTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:19:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbaAWSTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:19:09 -0500
Date: Thu, 23 Jan 2014 13:19:06 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 5/10] atyfb: remove resolution limit 1600
In-Reply-To: <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401231306220.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The card works fine in 1980x1080 resolution. Therefore, there is no need
to limit the resolution to 1600 pixels.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/video/aty/atyfb_base.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-3.11-rc7-fast/drivers/video/aty/atyfb_base.c
===================================================================
--- linux-3.11-rc7-fast.orig/drivers/video/aty/atyfb_base.c	2013-09-02 18:50:52.000000000 +0200
+++ linux-3.11-rc7-fast/drivers/video/aty/atyfb_base.c	2013-09-02 18:50:58.000000000 +0200
@@ -862,8 +862,8 @@ static int aty_var_to_crtc(const struct 
 	h_sync_pol = sync & FB_SYNC_HOR_HIGH_ACT ? 0 : 1;
 	v_sync_pol = sync & FB_SYNC_VERT_HIGH_ACT ? 0 : 1;
 
-	if ((xres > 1600) || (yres > 1200)) {
-		FAIL("MACH64 chips are designed for max 1600x1200\n"
+	if ((xres > 1920) || (yres > 1200)) {
+		FAIL("MACH64 chips are designed for max 1920x1200\n"
 		     "select another resolution.");
 	}
 	h_sync_strt = h_disp + var->right_margin;

