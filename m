Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759310Ab3BWVMd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 16:12:33 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:59683 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759255Ab3BWVM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 16:12:29 -0500
From: Sergei Trofimovich <slyich@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, user-mode-linux-user@lists.sourceforge.net,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>
Subject: [PATCH 1/2] um: add missing declaration of 'getrlimit()' and friends
Date: Sun, 24 Feb 2013 00:11:46 +0300
Message-Id: <1361653907-14510-2-git-send-email-slyich@gmail.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1361653907-14510-1-git-send-email-slyich@gmail.com>
References: <1361653907-14510-1-git-send-email-slyich@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

arch/um/os-Linux/start_up.c: In function 'check_coredump_limit':
arch/um/os-Linux/start_up.c:338:16: error: storage size of 'lim' isn't known
arch/um/os-Linux/start_up.c:339:2: error: implicit declaration of function 'getrlimit' [-Werror=implicit-function-declaration]

Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 arch/um/os-Linux/start_up.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/um/os-Linux/start_up.c b/arch/um/os-Linux/start_up.c
index da4b9e9..337518c 100644
--- a/arch/um/os-Linux/start_up.c
+++ b/arch/um/os-Linux/start_up.c
@@ -15,6 +15,8 @@
 #include <sys/mman.h>
 #include <sys/stat.h>
 #include <sys/wait.h>
+#include <sys/time.h>
+#include <sys/resource.h>
 #include <asm/unistd.h>
 #include <init.h>
 #include <os.h>
-- 
1.8.1.2

