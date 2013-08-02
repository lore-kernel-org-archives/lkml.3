Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab3HBXmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:42:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54521 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094Ab3HBXkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:40:40 -0400
Date: Fri, 2 Aug 2013 16:40:29 -0700
From: tip-bot for David Herrmann <tipbot@zytor.com>
Message-ID: <tip-9a6a36d19c9d24479300511e23933876a4a9cf82@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, hpa@linux.intel.com, dh.herrmann@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dh.herrmann@gmail.com, hpa@linux.intel.com
In-Reply-To: <1375445127-15480-6-git-send-email-dh.herrmann@gmail.com>
References: <1375445127-15480-6-git-send-email-dh.herrmann@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/fb] fbdev: simplefb: add common x86 RGB formats
Git-Commit-ID: 9a6a36d19c9d24479300511e23933876a4a9cf82
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 02 Aug 2013 16:40:35 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a6a36d19c9d24479300511e23933876a4a9cf82
Gitweb:     http://git.kernel.org/tip/9a6a36d19c9d24479300511e23933876a4a9cf82
Author:     David Herrmann <dh.herrmann@gmail.com>
AuthorDate: Fri, 2 Aug 2013 14:05:24 +0200
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 2 Aug 2013 16:17:48 -0700

fbdev: simplefb: add common x86 RGB formats

32bit XRGB and ARGB are used by modern x86 systems for EFI and VESA
framebuffers. The other formats were reported by hpa to be most common.
Add these so simplefb works on most common x86 systems.

Signed-off-by: David Herrmann <dh.herrmann@gmail.com>
Link: http://lkml.kernel.org/r/1375445127-15480-6-git-send-email-dh.herrmann@gmail.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 include/linux/platform_data/simplefb.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/platform_data/simplefb.h b/include/linux/platform_data/simplefb.h
index 5fa2c5e..53774b0 100644
--- a/include/linux/platform_data/simplefb.h
+++ b/include/linux/platform_data/simplefb.h
@@ -20,6 +20,13 @@
 #define SIMPLEFB_FORMATS \
 { \
 	{ "r5g6b5", 16, {11, 5}, {5, 6}, {0, 5}, {0, 0}, DRM_FORMAT_RGB565 }, \
+	{ "x1r5g5b5", 16, {10, 5}, {5, 5}, {0, 5}, {0, 0}, DRM_FORMAT_XRGB1555 }, \
+	{ "a1r5g5b5", 16, {10, 5}, {5, 5}, {0, 5}, {15, 1}, DRM_FORMAT_ARGB1555 }, \
+	{ "r8g8b8", 24, {16, 8}, {8, 8}, {0, 8}, {0, 0}, DRM_FORMAT_RGB888 }, \
+	{ "x8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {0, 0}, DRM_FORMAT_XRGB8888 }, \
+	{ "a8r8g8b8", 32, {16, 8}, {8, 8}, {0, 8}, {24, 8}, DRM_FORMAT_ARGB8888 }, \
+	{ "x2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {0, 0}, DRM_FORMAT_XRGB2101010 }, \
+	{ "a2r10g10b10", 32, {20, 10}, {10, 10}, {0, 10}, {30, 2}, DRM_FORMAT_ARGB2101010 }, \
 }
 
 /*
