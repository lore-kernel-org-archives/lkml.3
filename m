Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaHSHez (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 03:34:55 -0400
Received: from smtp.mei.co.jp ([133.183.100.20]:52720 "EHLO smtp.mei.co.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbaHSHex (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 03:34:53 -0400
From: Masahiro Yamada <yamada.m@jp.panasonic.com>
To: linux-kbuild@vger.kernel.org
Cc: Masahiro Yamada <yamada.m@jp.panasonic.com>,
        "Yann E. MORIN" <yann.morin.1998@free.fr>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] kbuild: refactor script/kconfig/Makefile
Date: Tue, 19 Aug 2014 16:34:22 +0900
Message-Id: <1408433663-17435-4-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1408433663-17435-1-git-send-email-yamada.m@jp.panasonic.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now it is harmless to add all host programs to hostprogs-y.

Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
---

 scripts/kconfig/Makefile | 34 +++-------------------------------
 1 file changed, 3 insertions(+), 31 deletions(-)

diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
index 9c4d241..76f6171 100644
--- a/scripts/kconfig/Makefile
+++ b/scripts/kconfig/Makefile
@@ -157,35 +157,7 @@ qconf-cxxobjs	:= qconf.o
 qconf-objs	:= zconf.tab.o
 gconf-objs	:= gconf.o zconf.tab.o
 
-hostprogs-y := conf
-
-ifeq ($(MAKECMDGOALS),nconfig)
-	hostprogs-y += nconf
-endif
-
-ifeq ($(MAKECMDGOALS),menuconfig)
-	hostprogs-y += mconf
-endif
-
-ifeq ($(MAKECMDGOALS),update-po-config)
-	hostprogs-y += kxgettext
-endif
-
-ifeq ($(MAKECMDGOALS),xconfig)
-	qconf-target := 1
-endif
-ifeq ($(MAKECMDGOALS),gconfig)
-	gconf-target := 1
-endif
-
-
-ifeq ($(qconf-target),1)
-	hostprogs-y += qconf
-endif
-
-ifeq ($(gconf-target),1)
-	hostprogs-y += gconf
-endif
+hostprogs-y := conf nconf mconf kxgettext qconf gconf
 
 clean-files	:= qconf.moc .tmp_qtcheck .tmp_gtkcheck
 clean-files	+= zconf.tab.c zconf.lex.c zconf.hash.c gconf.glade.h
@@ -224,7 +196,7 @@ HOSTLOADLIBES_nconf	= $(shell \
 				|| echo "-lmenu -lpanel -lncurses"  )
 $(obj)/qconf.o: $(obj)/.tmp_qtcheck
 
-ifeq ($(qconf-target),1)
+ifeq ($(MAKECMDGOALS),xconfig)
 $(obj)/.tmp_qtcheck: $(src)/Makefile
 -include $(obj)/.tmp_qtcheck
 
@@ -281,7 +253,7 @@ endif
 
 $(obj)/gconf.o: $(obj)/.tmp_gtkcheck
 
-ifeq ($(gconf-target),1)
+ifeq ($(MAKECMDGOALS),gconfig)
 -include $(obj)/.tmp_gtkcheck
 
 # GTK needs some extra effort, too...
-- 
1.9.1

