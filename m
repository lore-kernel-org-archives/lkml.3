Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752011AbaBMWIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 17:08:24 -0500
Received: from mailrelay001.isp.belgacom.be ([195.238.6.51]:4790 "EHLO
	mailrelay001.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751517AbaBMWIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 17:08:23 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmoUAElB/VJXQxZV/2dsb2JhbABZKIJewFgCAoEZF3SCZhwVDhiBAjeICQHISReOeR2EIgSJRo5lAYpPh1SDOi8
Date: Thu, 13 Feb 2014 22:09:42 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, rdunlap <rdunlap@infradead.org>
Subject: [PATCH 1/1] sys_sysfs: Add CONFIG_SYSFS_SYSCALL
Message-Id: <20140213220942.ff2ebaeff3876b7136fa4b10@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sys_sysfs is an obsolete system call no longer supported by libc ...
-This patch adds a default CONFIG_SYSFS_SYSCALL=y
-Option can be turned off in expert mode.
-cond_syscall added to kernel/sys_ni.c

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/filesystems.c |  2 ++
 init/Kconfig     | 10 ++++++++++
 kernel/sys_ni.c  |  1 +
 3 files changed, 13 insertions(+)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 92567d9..5797d45 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -121,6 +121,7 @@ int unregister_filesystem(struct file_system_type * fs)
 
 EXPORT_SYMBOL(unregister_filesystem);
 
+#ifdef CONFIG_SYSFS_SYSCALL
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
@@ -199,6 +200,7 @@ SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
 	}
 	return retval;
 }
+#endif
 
 int __init get_filesystem_list(char *buf)
 {
diff --git a/init/Kconfig b/init/Kconfig
index 009a797..013d13c 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1290,6 +1290,16 @@ config UID16
 	help
 	  This enables the legacy 16-bit UID syscall wrappers.
 
+config SYSFS_SYSCALL
+	bool "Sysfs syscall support" if EXPERT
+	default y
+	---help---
+	  sys_sysfs is an obsolete system call no longer supported in
+	  libc.Note that disabling this option while being more secure breaks
+	  compatibility with other systems.
+
+	  If unsure say Y here.
+
 config SYSCTL_SYSCALL
 	bool "Sysctl syscall support" if EXPERT
 	depends on PROC_SYSCTL
diff --git a/kernel/sys_ni.c b/kernel/sys_ni.c
index 7078052..74395a9 100644
--- a/kernel/sys_ni.c
+++ b/kernel/sys_ni.c
@@ -146,6 +146,7 @@ cond_syscall(sys_io_destroy);
 cond_syscall(sys_io_submit);
 cond_syscall(sys_io_cancel);
 cond_syscall(sys_io_getevents);
+cond_syscall(sys_sysfs);
 cond_syscall(sys_syslog);
 cond_syscall(sys_process_vm_readv);
 cond_syscall(sys_process_vm_writev);
-- 
1.8.1.4

