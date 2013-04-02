Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760773Ab3DBGKl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 02:10:41 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:39012 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760760Ab3DBGKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 02:10:40 -0400
From: "Edward O'Callaghan" <victoredwardocallaghan@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: "Edward O'Callaghan" <victoredwardocallaghan@gmail.com>
Subject: [PATCH] Build fix for ARM. The UAPI changes split kernel API and userspace API content onto two separate header files and assumed a full linux build. This trips up embedded builds.
Date: Tue,  2 Apr 2013 17:10:11 +1100
Message-Id: <1364883011-23256-1-git-send-email-victoredwardocallaghan@gmail.com>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Edward O'Callaghan <victoredwardocallaghan@gmail.com>
---
 include/uapi/drm/drm.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/uapi/drm/drm.h b/include/uapi/drm/drm.h
index 8d1e2bb..73a99e4 100644
--- a/include/uapi/drm/drm.h
+++ b/include/uapi/drm/drm.h
@@ -36,7 +36,7 @@
 #ifndef _DRM_H_
 #define _DRM_H_
 
-#if defined(__linux__)
+#if defined(__KERNEL__) || defined(__linux__)
 
 #include <linux/types.h>
 #include <asm/ioctl.h>
-- 
1.8.2

