Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755679AbaFWNbj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:31:39 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:60761 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754838AbaFWN3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:29:39 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: linux-kernel@vger.kernel.org
Cc: jirislaby@gmail.com, Vojtech Pavlik <vojtech@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>, Jiri Slaby <jslaby@suse.cz>,
        Udo Seidel <udoseidel@gmx.de>
Subject: [PATCH 06/21] kgr: add Documentation
Date: Mon, 23 Jun 2014 15:29:20 +0200
Message-Id: <1403530175-29217-6-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
References: <1403530175-29217-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a text provided by Udo and polished.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Udo Seidel <udoseidel@gmx.de>
---
 Documentation/kgraft.txt | 44 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 44 insertions(+)
 create mode 100644 Documentation/kgraft.txt

diff --git a/Documentation/kgraft.txt b/Documentation/kgraft.txt
new file mode 100644
index 000000000000..476beaf35c62
--- /dev/null
+++ b/Documentation/kgraft.txt
@@ -0,0 +1,44 @@
+Live Kernel Patching with kGraft
+--------------------------------
+
+Written by Udo Seidel <udoseidel at gmx dot de>
+Based on the Blog entry by Vojtech Pavlik
+Updated by Jiri Slaby
+
+June 2014
+
+kGraft's developement was started by the SUSE Labs. kGraft builds on
+technologies and ideas that are already present in the kernel: ftrace [1] and
+its mcount-based reserved space in function headers [2], the INT3/IPI-NMI
+patching also used in jump labels [3], and RCU-like update of code that does
+not require stopping the kernel.
+
+A kGraft patch is a kernel module and fully relies on the in-kernel module
+loader to link the new code with the kernel. Thanks to all that, the design
+can be nicely minimalistic.
+
+While kGraft is, by choice, limited to replacing whole functions and constants
+they reference, this does not limit the set of code patches that can be
+applied significantly.
+
+Use
+---
+
+1) Build a kernel with CONFIG_KGRAFT enabled
+2) Create a module with a patch
+   * Look at samples/kgraft/kgraft_patcher.c for an example
+3) Insert the module from 2) into the booted kernel from 1)
+4) All processes need to enter the kernel to acknowledge the new state
+   * This can be done e.g. by sending a non-fatal signal to all processes
+   * Check /proc/*/kgr_in_progress to check who still needs to be poked
+5) You should see "kgr succeeded" in dmesg now
+
+Enjoy your patched system!
+
+
+References
+----------
+
+[1] Documentation/trace/ftrace.txt
+[2] Documentation/trace/ftrace-design.txt
+[3] Documentation/static-keys.txt
-- 
2.0.0

