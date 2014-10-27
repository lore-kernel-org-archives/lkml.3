Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754054AbaJ0TTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 15:19:11 -0400
Received: from mail-wi0-f193.google.com ([209.85.212.193]:56343 "EHLO
	mail-wi0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753335AbaJ0TTI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 15:19:08 -0400
From: Nikos Giotis <nikos.giotis@gmail.com>
To: yann.morin.1998@free.fr
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        Nikos Giotis <nikos.giotis@gmail.com>
Subject: [PATCH] scripts/kconfig: Add tinfo library to linker library search
Date: Mon, 27 Oct 2014 21:18:37 +0200
Message-Id: <1414437517-23558-1-git-send-email-nikos.giotis@gmail.com>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For systems that have ncurses library configured with the
"--with termlib=tinfo" option the linker reports errors when
running "make menuconfig" due to undefined reference to symbol
'acs_map'. The change does not change the behaviour when
building against ncurses configured without this option. The
tinfo library is included in the lists of libraries that are
searched when buidling lxdialog sources.

Tested with kernel 3.14.22 and latest master from git

Signed-off-by: Nikos Giotis <nikos.giotis@gmail.com>
---
 scripts/kconfig/lxdialog/check-lxdialog.sh | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/scripts/kconfig/lxdialog/check-lxdialog.sh b/scripts/kconfig/lxdialog/check-lxdialog.sh
index 5075ebf..202e4bf 100755
--- a/scripts/kconfig/lxdialog/check-lxdialog.sh
+++ b/scripts/kconfig/lxdialog/check-lxdialog.sh
@@ -4,10 +4,10 @@
 # What library to link
 ldflags()
 {
-	pkg-config --libs ncursesw 2>/dev/null && exit
-	pkg-config --libs ncurses 2>/dev/null && exit
+	pkg-config --libs ncursesw tinfo 2>/dev/null && exit
+	pkg-config --libs ncurses tinfo 2>/dev/null && exit
 	for ext in so a dll.a dylib ; do
-		for lib in ncursesw ncurses curses ; do
+		for lib in ncursesw ncurses curses tinfo ; do
 			$cc -print-file-name=lib${lib}.${ext} | grep -q /
 			if [ $? -eq 0 ]; then
 				echo "-l${lib}"
-- 
1.8.4

