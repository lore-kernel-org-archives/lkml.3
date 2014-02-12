Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270AbaBLVD1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:03:27 -0500
Received: from mailrelay005.isp.belgacom.be ([195.238.6.171]:64341 "EHLO
	mailrelay005.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753705AbaBLVD0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:03:26 -0500
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AhwRAKbg+1JXQAka/2dsb2JhbABaKIJkgz68ewICgRgXdIJmHCMYgQI3iAkByRKOeR2EIgSJRo5jAZIhgzov
Date: Wed, 12 Feb 2014 21:04:40 +0800
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel@vger.kernel.org
Cc: akpm <akpm@linux-foundation.org>, rdunlap <rdunlap@infradead.org>
Subject: [RFC 2/2] Arch: Kconfig: Disable obsolete syscalls
Message-Id: <20140212210440.6148aaa3b75240627576ba3f@skynet.be>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fs: sysfs syscall: Disable if DISABLE_OBSOLETE_SYSCALLS

sysfs syscall is obsolete (cf man sysfs).

Don't define fs_index, fs_name, fs_maxindex functions when
DISABLE_OBSOLETE_SYSCALLS is defined.
In that case, SYSCALL_DEFINE3(sysfs...) returns automatically -EINVAL.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 fs/filesystems.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/filesystems.c b/fs/filesystems.c
index 92567d9..079626d 100644
--- a/fs/filesystems.c
+++ b/fs/filesystems.c
@@ -121,6 +121,7 @@ int unregister_filesystem(struct file_system_type * fs)
 
 EXPORT_SYMBOL(unregister_filesystem);
 
+#ifndef CONFIG_DISABLE_OBSOLETE_SYSCALLS
 static int fs_index(const char __user * __name)
 {
 	struct file_system_type * tmp;
@@ -199,6 +200,12 @@ SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
 	}
 	return retval;
 }
+#else
+SYSCALL_DEFINE3(sysfs, int, option, unsigned long, arg1, unsigned long, arg2)
+{
+	return -EINVAL;
+}
+#endif /*CONFIG_DISABLE_OBSOLETE_SYSCALLS*/
 
 int __init get_filesystem_list(char *buf)
 {
-- 
1.8.1.4

