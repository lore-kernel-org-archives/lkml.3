Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934002Ab3DOUld (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 16:41:33 -0400
Received: from mail-qe0-f74.google.com ([209.85.128.74]:45477 "EHLO
	mail-qe0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755573Ab3DOUlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 16:41:32 -0400
From: Colin Cross <ccross@android.com>
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Colin Cross <ccross@android.com>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel@lists.sourceforge.net (open list:FUSE: FILESYSTEM...)
Subject: [PATCH] fuse: use kernel headers when __KERNEL__ is set
Date: Mon, 15 Apr 2013 13:41:21 -0700
Message-Id: <1366058481-21033-1-git-send-email-ccross@android.com>
X-Mailer: git-send-email 1.8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 7e98d53086d18c877cb44e9065219335184024de (Synchronize fuse
header with one used in library) added #ifdef __linux__ around
defines if it is not set.  The kernel build is self-contained and
can be built on non-Linux toolchains.  After the mentioned commit
builds on non-Linux toolchains will try to include stdint.h and
fail due to -nostdinc, and then fail with a bunch of undefined
type errors.

Change the #ifdef to check for __linux__ or __KERNEL__ so that
it uses the kernel typedefs if __KERNEL__ is set.

Signed-off-by: Colin Cross <ccross@android.com>
---
I think this should go in v3.9, without it bare-metal toolchains
that don't define __linux__ will fail to compile the kernel, and
cross-compiles from non-linux hosts will probably also fail.

 include/uapi/linux/fuse.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/linux/fuse.h b/include/uapi/linux/fuse.h
index 4c43b44..5b79443 100644
--- a/include/uapi/linux/fuse.h
+++ b/include/uapi/linux/fuse.h
@@ -95,7 +95,7 @@
 #ifndef _LINUX_FUSE_H
 #define _LINUX_FUSE_H
 
-#ifdef __linux__
+#if defined(__linux__) || defined(__KERNEL__)
 #include <linux/types.h>
 #else
 #include <stdint.h>
-- 
1.8.1.3

