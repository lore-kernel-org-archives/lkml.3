Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671AbaJDNFq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2014 09:05:46 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:35940 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850AbaJDNFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2014 09:05:45 -0400
Message-ID: <542FF203.50907@gmail.com>
Date: Sat, 04 Oct 2014 21:11:31 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: richard@nod.at, jdike@addtoit.com
CC: user-mode-linux-devel@lists.sourceforge.net,
        user-mode-linux-user@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: [PATCH] um: kernel: ksyms: Export symbol syscall() for fixing modpost
 issue
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

syscall() is implemented in libc.so/a (e.g. for glibc, in "syscall.o"),
so for normal ".o" files, it is undefined, neither can be found within
kernel wide, so will break modpost.

Since ".o" files is OK, can simply export 'syscall' symbol, let modpost
know about that, then can fix this issue.

The related error (with allmodconfig under um):

    MODPOST 1205 modules
  ERROR: "syscall" [fs/hostfs/hostfs.ko] undefined!

Signed-off-by: Chen Gang <gang.chen.5i5j@gmail.com>
---
 arch/um/kernel/ksyms.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/um/kernel/ksyms.c b/arch/um/kernel/ksyms.c
index 543c047..e7780f3 100644
--- a/arch/um/kernel/ksyms.c
+++ b/arch/um/kernel/ksyms.c
@@ -42,3 +42,6 @@ EXPORT_SYMBOL(os_makedev);
 EXPORT_SYMBOL(add_sigio_fd);
 EXPORT_SYMBOL(ignore_sigio_fd);
 EXPORT_SYMBOL(sigio_broken);
+
+extern long int syscall (long int __sysno, ...);
+EXPORT_SYMBOL(syscall);
-- 
1.9.3
