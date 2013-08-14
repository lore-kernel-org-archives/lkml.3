Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760131Ab3HNQcn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:32:43 -0400
Received: from mail-oa0-f45.google.com ([209.85.219.45]:56291 "EHLO
	mail-oa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932716Ab3HNQbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:31:55 -0400
From: Zach Levis <zach@zachsthings.com>
To: akpm@linux-foundation.org, oleg@redhat.com
Cc: viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dan.carpenter@oracle.com,
        keescook@chromium.org, cody@linux.vnet.ibm.com, zml@linux.vnet.ibm.com,
        Zach Levis <zach@zachsthings.com>
Subject: [PATCH v4 1/3] fs/binfmts: Add a name field to the binfmt struct
Date: Wed, 14 Aug 2013 09:31:36 -0700
Message-Id: <1376497898-18619-2-git-send-email-zach@zachsthings.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
References: <1374766845-13565-1-git-send-email-zml@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding the name field helps when printing error messages referring to
specific binfmts

Signed-off-by: Zach Levis <zach@zachsthings.com>
---
 fs/binfmt_aout.c        |    1 +
 fs/binfmt_elf.c         |    5 +++++
 fs/binfmt_elf_fdpic.c   |    1 +
 fs/binfmt_em86.c        |    1 +
 fs/binfmt_flat.c        |    1 +
 fs/binfmt_misc.c        |    1 +
 fs/binfmt_script.c      |    1 +
 fs/binfmt_som.c         |    1 +
 fs/compat_binfmt_elf.c  |    5 +++++
 include/linux/binfmts.h |    1 +
 10 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/fs/binfmt_aout.c b/fs/binfmt_aout.c
index bce8769..f6bed04 100644
--- a/fs/binfmt_aout.c
+++ b/fs/binfmt_aout.c
@@ -115,6 +115,7 @@ end_coredump:
 #endif
 
 static struct linux_binfmt aout_format = {
+	.name		= "a.out",
 	.module		= THIS_MODULE,
 	.load_binary	= load_aout_binary,
 	.load_shlib	= load_aout_library,
diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
index f8a0b0e..864208b 100644
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -74,7 +74,12 @@ static int elf_core_dump(struct coredump_params *cprm);
 #define ELF_PAGEOFFSET(_v) ((_v) & (ELF_MIN_ALIGN-1))
 #define ELF_PAGEALIGN(_v) (((_v) + ELF_MIN_ALIGN - 1) & ~(ELF_MIN_ALIGN - 1))
 
+#ifndef ELF_FORMAT_NAME
+#define ELF_FORMAT_NAME "ELF"
+#endif
+
 static struct linux_binfmt elf_format = {
+	.name		= ELF_FORMAT_NAME,
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_binary,
 	.load_shlib	= load_elf_library,
diff --git a/fs/binfmt_elf_fdpic.c b/fs/binfmt_elf_fdpic.c
index c166f32..6be4448 100644
--- a/fs/binfmt_elf_fdpic.c
+++ b/fs/binfmt_elf_fdpic.c
@@ -81,6 +81,7 @@ static int elf_fdpic_core_dump(struct coredump_params *cprm);
 #endif
 
 static struct linux_binfmt elf_fdpic_format = {
+	.name		= "FDPIC ELF",
 	.module		= THIS_MODULE,
 	.load_binary	= load_elf_fdpic_binary,
 #ifdef CONFIG_ELF_CORE
diff --git a/fs/binfmt_em86.c b/fs/binfmt_em86.c
index 037a3e2..8404cdd 100644
--- a/fs/binfmt_em86.c
+++ b/fs/binfmt_em86.c
@@ -93,6 +93,7 @@ static int load_em86(struct linux_binprm *bprm)
 }
 
 static struct linux_binfmt em86_format = {
+	.name		= "em86",
 	.module		= THIS_MODULE,
 	.load_binary	= load_em86,
 };
diff --git a/fs/binfmt_flat.c b/fs/binfmt_flat.c
index d50bbe5..a7641e1 100644
--- a/fs/binfmt_flat.c
+++ b/fs/binfmt_flat.c
@@ -92,6 +92,7 @@ static int load_flat_binary(struct linux_binprm *);
 static int flat_core_dump(struct coredump_params *cprm);
 
 static struct linux_binfmt flat_format = {
+	.name		= "flat",
 	.module		= THIS_MODULE,
 	.load_binary	= load_flat_binary,
 	.core_dump	= flat_core_dump,
diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
index 1c740e1..d74afc0 100644
--- a/fs/binfmt_misc.c
+++ b/fs/binfmt_misc.c
@@ -694,6 +694,7 @@ static struct dentry *bm_mount(struct file_system_type *fs_type,
 }
 
 static struct linux_binfmt misc_format = {
+	.name	= "misc",
 	.module = THIS_MODULE,
 	.load_binary = load_misc_binary,
 };
diff --git a/fs/binfmt_script.c b/fs/binfmt_script.c
index 5027a3e..53f3c17 100644
--- a/fs/binfmt_script.c
+++ b/fs/binfmt_script.c
@@ -99,6 +99,7 @@ static int load_script(struct linux_binprm *bprm)
 }
 
 static struct linux_binfmt script_format = {
+	.name		= "script",
 	.module		= THIS_MODULE,
 	.load_binary	= load_script,
 };
diff --git a/fs/binfmt_som.c b/fs/binfmt_som.c
index 4e00ed6..1c3ccc5 100644
--- a/fs/binfmt_som.c
+++ b/fs/binfmt_som.c
@@ -53,6 +53,7 @@ static int som_core_dump(struct coredump_params *cprm);
 #define SOM_PAGEALIGN(_v) (((_v) + SOM_PAGESIZE - 1) & ~(SOM_PAGESIZE - 1))
 
 static struct linux_binfmt som_format = {
+	.name		= "SOM",
 	.module		= THIS_MODULE,
 	.load_binary	= load_som_binary,
 	.load_shlib	= load_som_library,
diff --git a/fs/compat_binfmt_elf.c b/fs/compat_binfmt_elf.c
index a81147e..96330f3 100644
--- a/fs/compat_binfmt_elf.c
+++ b/fs/compat_binfmt_elf.c
@@ -131,9 +131,14 @@ static void cputime_to_compat_timeval(const cputime_t cputime,
  * might make some debugging less confusing not to duplicate them.
  */
 #define elf_format		compat_elf_format
+#define elf_format_name compat_elf_format_name
 #define init_elf_binfmt		init_compat_elf_binfmt
 #define exit_elf_binfmt		exit_compat_elf_binfmt
 
+#ifndef ELF_FORMAT_NAME
+#define ELF_FORMAT_NAME "ELF compat"
+#endif
+
 /*
  * We share all the actual code with the native (64-bit) version.
  */
diff --git a/include/linux/binfmts.h b/include/linux/binfmts.h
index 70cf138..402a74a 100644
--- a/include/linux/binfmts.h
+++ b/include/linux/binfmts.h
@@ -70,6 +70,7 @@ struct coredump_params {
 struct linux_binfmt {
 	struct list_head lh;
 	struct module *module;
+	const char *name;
 	int (*load_binary)(struct linux_binprm *);
 	int (*load_shlib)(struct file *);
 	int (*core_dump)(struct coredump_params *cprm);
-- 
1.7.1

