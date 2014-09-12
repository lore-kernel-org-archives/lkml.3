Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752424AbaILGuG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:50:06 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:55749 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbaILGuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:50:03 -0400
From: gxt@mprc.pku.edu.cn
To: linux-kernel@vger.kernel.org
Cc: gxt@pku.edu.cn, linux@roeck-us.net, gang.chen.5i5j@gmail.com,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Qin Rui <qinrui@pku.edu.cn>
Subject: [PATCH 1/4] unicore32-oldabi: add CONFIG_UNICORE32_OLDABI for distinguishing two ABIs
Date: Fri, 12 Sep 2014 14:41:43 +0800
Message-Id: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 2.0.0.GIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Qin Rui <qinrui@pku.edu.cn>
---
 arch/unicore32/Kconfig | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/arch/unicore32/Kconfig b/arch/unicore32/Kconfig
index 928237a..e5d25b4 100644
--- a/arch/unicore32/Kconfig
+++ b/arch/unicore32/Kconfig
@@ -72,6 +72,17 @@ source "kernel/Kconfig.freezer"
 
 menu "System Type"
 
+config UNICORE32_OLDABI
+	bool "Allow old ABI binaries to run with this kernel"
+	default y
+	help
+	  This option preserves the old syscall interface instead of the
+	  asm-generic one. It also provides a compatibility layer to
+	  intercept syscalls that have structure arguments which layout
+	  in memory differs between the asm-generic ABI and this old one.
+
+	  If in doubt, say Y.
+
 config MMU
 	def_bool y
 
-- 
2.0.0.GIT

