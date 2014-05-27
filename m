Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752696AbaE0ONX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 10:13:23 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:49144 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215AbaE0ONW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 10:13:22 -0400
Subject: [PATCH] mm/process_vm_access: move config option into init/Kconfig
From: Konstantin Khlebnikov <koct9i@gmail.com>
To: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Davidlohr Bueso <davidlohr@hp.com>, Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Tue, 27 May 2014 18:13:13 +0400
Message-ID: <20140527141313.23853.29306.stgit@zurg>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_CROSS_MEMORY_ATTACH adds couple syscalls: process_vm_readv and
process_vm_writev, it's a kind of IPC for copying data between processes.
Currently this option is placed inside "Processor type and features".

This patch moves it into "General setup" (where all other arch-independed
syscalls and ipc features are placed) and changes prompt string to less cryptic.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 init/Kconfig |   10 ++++++++++
 mm/Kconfig   |   10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9d3585b..d6ddb7a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -261,6 +261,16 @@ config POSIX_MQUEUE_SYSCTL
 	depends on SYSCTL
 	default y
 
+config CROSS_MEMORY_ATTACH
+	bool "Enable process_vm_readv/writev syscalls"
+	depends on MMU
+	default y
+	help
+	  Enabling this option adds the system calls process_vm_readv and
+	  process_vm_writev which allow a process with the correct privileges
+	  to directly read from or write to to another process's address space.
+	  See the man page for more details.
+
 config FHANDLE
 	bool "open by fhandle syscalls"
 	select EXPORTFS
diff --git a/mm/Kconfig b/mm/Kconfig
index 1b5a95f..2ec35d7 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -430,16 +430,6 @@ choice
 	  benefit.
 endchoice
 
-config CROSS_MEMORY_ATTACH
-	bool "Cross Memory Support"
-	depends on MMU
-	default y
-	help
-	  Enabling this option adds the system calls process_vm_readv and
-	  process_vm_writev which allow a process with the correct privileges
-	  to directly read from or write to to another process's address space.
-	  See the man page for more details.
-
 #
 # UP and nommu archs use km based percpu allocator
 #

