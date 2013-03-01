Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751823Ab3CAPuu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:50:50 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:60169 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab3CAPus (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:50:48 -0500
From: jlec@gentoo.org
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Justin Lecher <jlec@gentoo.org>
Subject: [PATCH 1/2] menuconfig: use config scripts to detect ncurses libs
Date: Fri,  1 Mar 2013 16:50:43 +0100
Message-Id: <1362153044-23611-2-git-send-email-jlec@gentoo.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1362153044-23611-1-git-send-email-jlec@gentoo.org>
References: <jlec@gentoo.org>
 <1362153044-23611-1-git-send-email-jlec@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Lecher <jlec@gentoo.org>

When building ncurses with --with-termlib several symbols get moved from
libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
additionally needs to link with libtinfo.so. Ncurses provides a config script
(ncurses5-config) or in very recent version even a pkg-config module to assist
finding ncurses.

The old heuristic for detection of ncurses libs will be extended to the
pkg-config and the config scripts.

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 8078813..8086874 100644
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,6 +4,12 @@
 # What library to link
 ldflags()
 {
+	pkg-config --libs ncursesw 2>/dev/null && exit
+	pkg-config --libs ncurses 2>/dev/null && exit
+	ncursesw5-config --libs 2>/dev/null && exit
+	ncurses5-config --libs 2>/dev/null && exit
+	ncursesw6-config --libs 2>/dev/null && exit
+	ncurses6-config --libs 2>/dev/null && exit
 	for ext in so a dll.a dylib ; do
 		for lib in ncursesw ncurses curses ; do
 			$cc -print-file-name=lib${lib}.${ext} | grep -q /
-- 
1.8.1.4

