Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754826Ab3CFNCM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:02:12 -0500
Received: from mail.not-your-server.de ([78.46.182.243]:46095 "EHLO
	mail.not-your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750798Ab3CFNCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:02:07 -0500
From: jlec@gentoo.org
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Justin Lecher <jlec@gentoo.org>
Subject: [PATCH 2/2] kconfig: optionally use pkg-config to detect ncurses libs
Date: Wed,  6 Mar 2013 14:02:02 +0100
Message-Id: <1362574922-4799-3-git-send-email-jlec@gentoo.org>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1362574922-4799-1-git-send-email-jlec@gentoo.org>
References: <Use config scripts to detect ncurses libs for, menuconfig/nconfig dialogs>
 <1362574922-4799-1-git-send-email-jlec@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Justin Lecher <jlec@gentoo.org>

When building ncurses with --with-termlib several symbols get moved from
libncurses.so to libtinfo.so. Thus when linking with libncurses.so, one
additionally needs to link with libtinfo.so.

The ncurses pkg-config module will be used to detect the necessary libs for
linking. If not available the old way of directly specifying libs will be
used.

Signed-off-by: Justin Lecher <jlec@gentoo.org>
---
 scripts/kconfig/Makefile | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 231b475..e76ae5d 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -219,7 +219,9 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
 
 HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
 
-HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
+HOSTLOADLIBES_nconf	= $(shell \
+				pkg-config --libs menu panel ncurses 2>/dev/null \
+				|| echo "-lmenu -lpanel -ncurses"  )
 $(obj)/qconf.o: $(obj)/.tmp_qtcheck
 
 ifeq ($(qconf-target),1)
-- 
1.8.1.5

