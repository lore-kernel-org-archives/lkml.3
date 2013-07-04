Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933611Ab3GDDgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 23:36:35 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:36903 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933440Ab3GDDd1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 23:33:27 -0400
From: Waiman Long <Waiman.Long@hp.com>
Cc: Waiman Long <Waiman.Long@hp.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Andi Kleen <andi@firstfloor.org>,
        "Chandramouleeswaran, Aswin" <aswin@hp.com>,
        "Norton, Scott J" <scott.norton@hp.com>
Subject: [PATCH v4 02/12] spinlock: Enable x86 architecture to do lockless refcount update
Date: Wed,  3 Jul 2013 23:32:50 -0400
Message-Id: <1372908771-33260-3-git-send-email-Waiman.Long@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1372908771-33260-1-git-send-email-Waiman.Long@hp.com>
References: <1372908771-33260-1-git-send-email-Waiman.Long@hp.com>
To: Alexander Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        Miklos Szeredi <mszeredi@suse.cz>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are two steps to enable each architecture to do lockless
reference count update:
1. Define the ARCH_SPINLOCK_REFCOUNT config parameter in its Kconfig
   file.
2. Add a <asm/spinlock_refcount.h> architecture specific header file.

This is done for the x86 architecture to use the generic version
available.

Signed-off-by: Waiman Long <Waiman.Long@hp.com>
---
 arch/x86/Kconfig                         |    3 +++
 arch/x86/include/asm/spinlock_refcount.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)
 create mode 100644 arch/x86/include/asm/spinlock_refcount.h

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fe120da..649ed4b 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -253,6 +253,9 @@ config ARCH_CPU_PROBE_RELEASE
 config ARCH_SUPPORTS_UPROBES
 	def_bool y
 
+config ARCH_SPINLOCK_REFCOUNT
+	def_bool y
+
 source "init/Kconfig"
 source "kernel/Kconfig.freezer"
 
diff --git a/arch/x86/include/asm/spinlock_refcount.h b/arch/x86/include/asm/spinlock_refcount.h
new file mode 100644
index 0000000..ab6224f
--- /dev/null
+++ b/arch/x86/include/asm/spinlock_refcount.h
@@ -0,0 +1 @@
+#include <asm-generic/spinlock_refcount.h>
-- 
1.7.1

