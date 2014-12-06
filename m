Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973AbaLFR4l (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 12:56:41 -0500
Received: from 1wt.eu ([62.212.114.60]:40766 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaLFRzT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 12:55:19 -0500
Message-Id: <20141206174148.719193237@1wt.eu>
User-Agent: quilt/0.63-1
Date: Sat, 06 Dec 2014 18:41:55 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 07/25] x86, espfix: Move espfix definitions into a separate
 header file
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
In-Reply-To: <2a26e912d2438674771c36169c190830@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: "H. Peter Anvin" <hpa@linux.intel.com>

commit e1fe9ed8d2a4937510d0d60e20705035c2609aea upstream.

Sparse warns that the percpu variables aren't declared before they are
defined.  Rather than hacking around it, move espfix definitions into
a proper header file.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
(cherry picked from 3.2 commit 62358ee6bb9d3d9dd4761d39ac0e1ede9ba70b0e)
[wt: using DECLARE_PER_CPU instead of DECLARE_PER_CPU_READ_MOSTLY]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/include/asm/espfix.h | 16 ++++++++++++++++
 arch/x86/include/asm/setup.h  |  2 ++
 arch/x86/kernel/espfix_64.c   |  1 +
 3 files changed, 19 insertions(+)
 create mode 100644 arch/x86/include/asm/espfix.h

diff --git a/arch/x86/include/asm/espfix.h b/arch/x86/include/asm/espfix.h
new file mode 100644
index 0000000..e2fb446
--- /dev/null
+++ b/arch/x86/include/asm/espfix.h
@@ -0,0 +1,16 @@
+#ifdef _ASM_X86_ESPFIX_H
+#define _ASM_X86_ESPFIX_H
+
+#ifdef CONFIG_X86_64
+
+#include <asm/percpu.h>
+
+DECLARE_PER_CPU(unsigned long, espfix_stack);
+DECLARE_PER_CPU(unsigned long, espfix_waddr);
+
+extern void init_espfix_bsp(void);
+extern void init_espfix_ap(void);
+
+#endif /* CONFIG_X86_64 */
+
+#endif /* _ASM_X86_ESPFIX_H */
diff --git a/arch/x86/include/asm/setup.h b/arch/x86/include/asm/setup.h
index 18e496c..ac45d3b 100644
--- a/arch/x86/include/asm/setup.h
+++ b/arch/x86/include/asm/setup.h
@@ -57,6 +57,8 @@ static inline void x86_mrst_early_setup(void) { }
 
 #ifndef _SETUP
 
+#include <asm/espfix.h>
+
 /*
  * This is set up by the setup-routine at boot-time
  */
diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index ae10040..24bd342 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -40,6 +40,7 @@
 #include <asm/pgtable.h>
 #include <asm/pgalloc.h>
 #include <asm/setup.h>
+#include <asm/espfix.h>
 
 /*
  * Note: we only need 6*8 = 48 bytes for the espfix stack, but round
-- 
1.7.12.2.21.g234cd45.dirty



