Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932426AbaAWSTA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 13:19:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138AbaAWSS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 13:18:58 -0500
Date: Thu, 23 Jan 2014 13:18:56 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: linux-kernel@vger.kernel.org
Subject: [PATCH 4/10] atyfb: set FBINFO_READS_FAST
In-Reply-To: <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
Message-ID: <alpine.LRH.2.02.1401231305390.31739@file01.intranet.prod.int.rdu2.redhat.com>
References: <alpine.LRH.2.02.1401231259340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231302340.31739@file01.intranet.prod.int.rdu2.redhat.com> <alpine.LRH.2.02.1401231303100.31739@file01.intranet.prod.int.rdu2.redhat.com>
 <alpine.LRH.2.02.1401231303460.31739@file01.intranet.prod.int.rdu2.redhat.com>
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
32bpp	4.9	3.6
24bpp	4.9	2.9
16bpp	4.9	2.1
8bpp	4.9	1.7

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/video/aty/atyfb_base.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

Index: linux-3.13-rc1/drivers/video/aty/atyfb_base.c
===================================================================
--- linux-3.13-rc1.orig/drivers/video/aty/atyfb_base.c	2013-11-27 00:25:42.000000000 +0100
+++ linux-3.13-rc1/drivers/video/aty/atyfb_base.c	2013-11-27 00:25:55.000000000 +0100
@@ -2653,7 +2653,8 @@ static int aty_init(struct fb_info *info
 		      FBINFO_HWACCEL_IMAGEBLIT |
 		      FBINFO_HWACCEL_FILLRECT  |
 		      FBINFO_HWACCEL_COPYAREA  |
-		      FBINFO_HWACCEL_YPAN;
+		      FBINFO_HWACCEL_YPAN      |
+		      FBINFO_READS_FAST;
 
 #ifdef CONFIG_PMAC_BACKLIGHT
 	if (M64_HAS(G3_PB_1_1) && of_machine_is_compatible("PowerBook1,1")) {

