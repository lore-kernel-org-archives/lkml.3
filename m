Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321AbaILGuF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 02:50:05 -0400
Received: from mprc.pku.edu.cn ([162.105.203.9]:55750 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751841AbaILGuD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 02:50:03 -0400
X-Greylist: delayed 927 seconds by postgrey-1.27 at vger.kernel.org; Fri, 12 Sep 2014 02:50:03 EDT
From: gxt@mprc.pku.edu.cn
To: linux-kernel@vger.kernel.org
Cc: gxt@pku.edu.cn, linux@roeck-us.net, gang.chen.5i5j@gmail.com,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, Qin Rui <qinrui@pku.edu.cn>
Subject: [PATCH 3/4] unicore32-oldabi: add sigcontext.h support for UNICORE32_OLDABI
Date: Fri, 12 Sep 2014 14:41:45 +0800
Message-Id: <e5292e02c8bc713e2ec0e41103d16e660f411d30.1410502415.git.gxt@mprc.pku.edu.cn>
X-Mailer: git-send-email 2.0.0.GIT
In-Reply-To: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
References: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
In-Reply-To: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
References: <1b5cc90293670926b5a1e5a06995e527442f8bde.1410502415.git.gxt@mprc.pku.edu.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guan Xuetao <gxt@mprc.pku.edu.cn>

Signed-off-by: Guan Xuetao <gxt@mprc.pku.edu.cn>
Signed-off-by: Qin Rui <qinrui@pku.edu.cn>
---
 arch/unicore32/include/uapi/asm/sigcontext.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/arch/unicore32/include/uapi/asm/sigcontext.h b/arch/unicore32/include/uapi/asm/sigcontext.h
index 6a2d767..cbc3446 100644
--- a/arch/unicore32/include/uapi/asm/sigcontext.h
+++ b/arch/unicore32/include/uapi/asm/sigcontext.h
@@ -18,6 +18,7 @@
  * before the signal handler was invoked.  Note: only add new entries
  * to the end of the structure.
  */
+#ifndef CONFIG_UNICORE32_OLDABI
 struct sigcontext {
 	unsigned long trap_no;
 	unsigned long error_code;
@@ -25,5 +26,18 @@ struct sigcontext {
 	unsigned long fault_address;
 	struct pt_regs regs;
 };
+#else
+struct pt_regs_sigcontext {
+	unsigned long uregs[33];
+};
+
+struct sigcontext {
+	unsigned long trap_no;
+	unsigned long error_code;
+	unsigned long oldmask;
+	struct pt_regs_sigcontext regs;
+	unsigned long fault_address;
+};
+#endif /* CONFIG_UNICORE32_OLDABI */
 
 #endif
-- 
2.0.0.GIT

