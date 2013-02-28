Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab3B1LwY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 06:52:24 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:56350 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752040Ab3B1LwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 06:52:20 -0500
From: jlec@gentoo.org
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Justin Lecher <jlec@gentoo.org>
Subject: [PATCH] menuconfig: use config scripts to detect ncurses libs
Date: Thu, 28 Feb 2013 12:52:15 +0100
Message-Id: <1362052335-17913-1-git-send-email-jlec@gentoo.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <jlec@gentoo.org>
References: <jlec@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Lecher <jlec@gentoo.org>

When building ncurses with --with-termlib several symbols get moved from
libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
additionally needs to link with libtinfo.so. Ncurses provides a config script
(ncurses5-config) to assist finding ncurses.

This patch replaces the old heuristic for detection of ncurses libs for
linking the ncurses menuconfig dialog by the use of the config scripts.
This results in the requirement of ncurses version 5.6 or newer for menuconfig.

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index c8e8a71..10df55b 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,15 +4,8 @@
 # What library to link
 ldflags()
 {
-	for ext in so a dll.a dylib ; do
-		for lib in ncursesw ncurses curses ; do
-			$cc -print-file-name=lib${lib}.${ext} | grep -q /
-			if [ $? -eq 0 ]; then
-				echo "-l${lib}"
-				exit
-			fi
-		done
-	done
+	ncursesw5-config --libs 2>/dev/null && exit
+	ncurses5-config --libs 2>/dev/null && exit
 	exit 1
 }
 
-- 
1.8.1.4

