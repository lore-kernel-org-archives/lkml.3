Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598AbaB0MZ2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 07:25:28 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42030 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaB0MZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 07:25:23 -0500
Date: Thu, 27 Feb 2014 17:53:08 +0530
From: Rashika Kheria <rashika.kheria@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rashika Kheria <rashika.kheria@gmail.com>,
        Al Viro <viro@zeniv.linux.org.uk>, josh@joshtriplett.org
Subject: [PATCH 38/46] kernel: Include appropriate header file in
 kernel/elfcore.c
Message-ID: <2ad027b197a4960918142bb39e7c204ccecccebe.1393493277.git.rashika.kheria@gmail.com>
References: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7b4a60c74ced00e0d65c38488f20dc4bd69f0dd2.1393493276.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Include appropriate header file include/linux/elfcore.h in
kernel/elfcore.c because it has prototype declaration of function
defined in kernel/elfcore.c.

This eliminates the following warning in kernel/elfcore.c:
kernel/elfcore.c:6:17: warning: no previous prototype for ‘elf_core_extra_phdrs’ [-Wmissing-prototypes]
kernel/elfcore.c:11:12: warning: no previous prototype for ‘elf_core_write_extra_phdrs’ [-Wmissing-prototypes]
kernel/elfcore.c:16:12: warning: no previous prototype for ‘elf_core_write_extra_data’ [-Wmissing-prototypes]
kernel/elfcore.c:21:15: warning: no previous prototype for ‘elf_core_extra_data_size’ [-Wmissing-prototypes]

Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/elfcore.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/elfcore.c b/kernel/elfcore.c
index e556751..a2b29b9 100644
--- a/kernel/elfcore.c
+++ b/kernel/elfcore.c
@@ -2,6 +2,7 @@
 #include <linux/fs.h>
 #include <linux/mm.h>
 #include <linux/binfmts.h>
+#include <linux/elfcore.h>
 
 Elf_Half __weak elf_core_extra_phdrs(void)
 {
-- 
1.7.9.5

