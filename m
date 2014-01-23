Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381AbaAWSSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:18:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:62419 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350AbaAWSSU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:18:20 -0500
Date: Thu, 23 Jan 2014 13:18:18 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 1/10] matroxfb: set FBINFO_READS_FAST
In-Reply-To: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set FBINFO_READS_FAST so that the console code uses scrolling instead of
rewriting. This improves scrolling speed.

A time to do ls -la /usr/bin:
	original patched
32bpp	5.4	3.6
24bpp	5.1	3.0
16bpp	4.9	2.5
8bpp	4.9	2.0

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/video/matrox/matroxfb_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.12.1/drivers/video/matrox/matroxfb_base.c
===================================================================
--- linux-3.12.1.orig/drivers/video/matrox/matroxfb_base.c	2013-11-18 18:14:25.000000000 +0100
+++ linux-3.12.1/drivers/video/matrox/matroxfb_base.c	2013-11-23 17:58:47.000000000 +0100
@@ -1773,7 +1773,8 @@ static int initMatrox2(struct matrox_fb_
 				      FBINFO_HWACCEL_FILLRECT |  /* And fillrect */
 				      FBINFO_HWACCEL_IMAGEBLIT | /* And imageblit */
 				      FBINFO_HWACCEL_XPAN |      /* And we support both horizontal */
-				      FBINFO_HWACCEL_YPAN;       /* And vertical panning */
+				      FBINFO_HWACCEL_YPAN |      /* And vertical panning */
+				      FBINFO_READS_FAST;
 	minfo->video.len_usable &= PAGE_MASK;
 	fb_alloc_cmap(&minfo->fbcon.cmap, 256, 1);
 

