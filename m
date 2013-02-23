Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759289Ab3BWVMc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:12:32 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59686 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759256Ab3BWVM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:12:29 -0500
From: Sergei Trofimovich <slyich@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 2/2] um: fix build failure due to mess-up of sig_info protorype
Date: Sun, 24 Feb 2013 00:11:47 +0300
Message-Id: <1361653907-14510-3-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361653907-14510-1-git-send-email-slyich@gmail.com>
References: <1361653907-14510-1-git-send-email-slyich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

arch/um/os-Linux/signal.c:18:8: error: conflicting types for 'sig_info'
In file included from /home/slyfox/linux-2.6/arch/um/os-Linux/signal.c:12:0:
arch/um/include/shared/as-layout.h:64:15: note: previous declaration of 'sig_info' was here

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 arch/um/os-Linux/signal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/um/os-Linux/signal.c b/arch/um/os-Linux/signal.c
index b1469fe..9d9f1b4 100644
--- a/arch/um/os-Linux/signal.c
+++ b/arch/um/os-Linux/signal.c
@@ -15,7 +15,7 @@
 #include <sysdep/mcontext.h>
 #include "internal.h"
 
-void (*sig_info[NSIG])(int, siginfo_t *, struct uml_pt_regs *) = {
+void (*sig_info[NSIG])(int, struct siginfo *, struct uml_pt_regs *) = {
 	[SIGTRAP]	= relay_signal,
 	[SIGFPE]	= relay_signal,
 	[SIGILL]	= relay_signal,
-- 
1.8.1.2

