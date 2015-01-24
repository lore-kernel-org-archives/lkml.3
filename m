Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbbAXSLq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jan 2015 13:11:46 -0500
Received: from mail-la0-f47.google.com ([209.85.215.47]:43345 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261AbbAXSLn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jan 2015 13:11:43 -0500
From: Alexander Kuleshov <kuleshovmail@gmail.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Martin Mares <mj@ucw.cz>, Ingo Molnar <mingo@redhat.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Alexander Kuleshov <kuleshovmail@gmail.com>
Subject: [PATCH] x86/boot/video: move video_segment variable to video.c
Date: Sun, 25 Jan 2015 00:11:32 +0600
Message-Id: <1422123092-28750-1-git-send-email-kuleshovmail@gmail.com>
X-Mailer: git-send-email 2.3.0.rc1.275.g028c360
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's only user of the video_segment variable, so move it to video.c

Signed-off-by: Alexander Kuleshov <kuleshovmail@gmail.com>
---
 arch/x86/boot/video-mode.c | 4 +---
 arch/x86/boot/video.c      | 2 ++
 arch/x86/boot/video.h      | 1 -
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/arch/x86/boot/video-mode.c b/arch/x86/boot/video-mode.c
index 748e8d0..aa8a96b 100644
--- a/arch/x86/boot/video-mode.c
+++ b/arch/x86/boot/video-mode.c
@@ -22,10 +22,8 @@
 /*
  * Common variables
  */
-int adapter;			/* 0=CGA/MDA/HGC, 1=EGA, 2=VGA+ */
-u16 video_segment;
+int adapter;		/* 0=CGA/MDA/HGC, 1=EGA, 2=VGA+ */
 int force_x, force_y;	/* Don't query the BIOS for cols/rows */
-
 int do_restore;		/* Screen contents changed during mode flip */
 int graphic_mode;	/* Graphic mode with linear frame buffer */
 
diff --git a/arch/x86/boot/video.c b/arch/x86/boot/video.c
index 43eda28..05111bb 100644
--- a/arch/x86/boot/video.c
+++ b/arch/x86/boot/video.c
@@ -17,6 +17,8 @@
 #include "video.h"
 #include "vesa.h"
 
+static u16 video_segment;
+
 static void store_cursor_position(void)
 {
 	struct biosregs ireg, oreg;
diff --git a/arch/x86/boot/video.h b/arch/x86/boot/video.h
index 0bb2549..b54e032 100644
--- a/arch/x86/boot/video.h
+++ b/arch/x86/boot/video.h
@@ -91,7 +91,6 @@ int mode_defined(u16 mode);	/* video.c */
 #define ADAPTER_VGA	2
 
 extern int adapter;
-extern u16 video_segment;
 extern int force_x, force_y;	/* Don't query the BIOS for cols/rows */
 extern int do_restore;		/* Restore screen contents */
 extern int graphic_mode;	/* Graphics mode with linear frame buffer */
-- 
2.3.0.rc1.275.g028c360

