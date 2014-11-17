Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaKQBbH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2014 20:31:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59559 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178AbaKQBab (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2014 20:30:31 -0500
From: Seth Jennings <sjenning@redhat.com>
To: Josh Poimboeuf <jpoimboe@redhat.com>, Seth Jennings <sjenning@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Vojtech Pavlik <vojtech@suse.cz>,
        Steven Rostedt <rostedt@goodmis.org>, Petr Mladek <pmladek@suse.cz>,
        Miroslav Benes <mbenes@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        live-patching@vger.kernel.org, x86@kernel.org, kpatch@redhat.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 3/3] kernel: add sysfs documentation for live patching
Date: Sun, 16 Nov 2014 19:29:24 -0600
Message-Id: <1416187764-3341-4-git-send-email-sjenning@redhat.com>
In-Reply-To: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
References: <1416187764-3341-1-git-send-email-sjenning@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adds sysfs interface documentation to Documentation/ABI/testing/

Signed-off-by: Seth Jennings <sjenning@redhat.com>
---
 Documentation/ABI/testing/sysfs-kernel-livepatch | 44 ++++++++++++++++++++++++
 MAINTAINERS                                      |  1 +
 2 files changed, 45 insertions(+)
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-livepatch

diff --git a/Documentation/ABI/testing/sysfs-kernel-livepatch b/Documentation/ABI/testing/sysfs-kernel-livepatch
new file mode 100644
index 0000000..5bf42a8
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-livepatch
@@ -0,0 +1,44 @@
+What:		/sys/kernel/livepatch
+Date:		Nov 2014
+KernelVersion:	3.19.0
+Contact:	live-patching@vger.kernel.org
+Description:
+		Interface for kernel live patching
+
+		The /sys/kernel/livepatch directory contains subdirectories for
+		each loaded live patch module.
+
+What:		/sys/kernel/livepatch/<patch>
+Date:		Nov 2014
+KernelVersion:	3.19.0
+Contact:	live-patching@vger.kernel.org
+Description:
+		The patch directory contains subdirectories for each kernel
+		object (vmlinux or a module) in which it patched functions.
+
+What:		/sys/kernel/livepatch/<patch>/enabled
+Date:		Nov 2014
+KernelVersion:	3.19.0
+Contact:	live-patching@vger.kernel.org
+Description:
+		A writable attribute that indicates whether the patched
+		code is currently applied.  Writing 0 will disable the patch
+		while writing 1 will re-enable the patch.
+
+What:		/sys/kernel/livepatch/<patch>/<object>
+Date:		Nov 2014
+KernelVersion:	3.19.0
+Contact:	live-patching@vger.kernel.org
+Description:
+		The object directory contains subdirectories for each function
+		that is patched within the object.
+
+What:		/sys/kernel/livepatch/<patch>/<object>/<function>
+Date:		Nov 2014
+KernelVersion:	3.19.0
+Contact:	live-patching@vger.kernel.org
+Description:
+		The function directory contains attributes regarding the
+		properties and state of the patched function.
+
+		There are currently no such attributes.
diff --git a/MAINTAINERS b/MAINTAINERS
index c7f49ae..7985293 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5725,6 +5725,7 @@ F:	kernel/livepatch/
 F:	include/linux/livepatch.h
 F:	arch/x86/include/asm/livepatch.h
 F:	arch/x86/kernel/livepatch.c
+F:	Documentation/ABI/testing/sysfs-kernel-livepatch
 L:	live-patching@vger.kernel.org
 
 LLC (802.2)
-- 
1.9.3

