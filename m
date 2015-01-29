Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758845AbbA2G6a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:58:30 -0500
Received: from david.siemens.de ([192.35.17.14]:58352 "EHLO david.siemens.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750842AbbA2G5Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:57:24 -0500
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH v11 23/28] scripts/gdb: Ignore byte-compiled python files
Date: Thu, 29 Jan 2015 07:46:42 +0100
Message-Id: <fd0c2a6ad6e1d021ce85798f9cd89d9e3381288e.1422514006.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1422514006.git.jan.kiszka@siemens.com>
References: <cover.1422514006.git.jan.kiszka@siemens.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Thompson <daniel.thompson@linaro.org>

Using the gdb scripts leaves byte-compiled python files in the scripts/
directory. These should be ignored by git and cleaned up by mrproper.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
Signed-off-by: Jan Kiszka <jan.kiszka@siemens.com>
---
 .gitignore                   | 1 +
 Makefile                     | 3 ++-
 scripts/gdb/linux/.gitignore | 2 ++
 3 files changed, 5 insertions(+), 1 deletion(-)
 create mode 100644 scripts/gdb/linux/.gitignore

diff --git a/.gitignore b/.gitignore
index ce57b79..ecb89e3 100644
--- a/.gitignore
+++ b/.gitignore
@@ -43,6 +43,7 @@ Module.symvers
 /TAGS
 /linux
 /vmlinux
+/vmlinux-gdb.py
 /vmlinuz
 /System.map
 /Module.markers
diff --git a/Makefile b/Makefile
index 6881ddf..ee7394e 100644
--- a/Makefile
+++ b/Makefile
@@ -1179,7 +1179,8 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
-		  signing_key.x509.signer vmlinux-gdb.py
+		  signing_key.x509.signer vmlinux-gdb.py		\
+		  scripts/gdb/linux/*.py[co]
 
 # clean - Delete most, but leave enough to build external modules
 #
diff --git a/scripts/gdb/linux/.gitignore b/scripts/gdb/linux/.gitignore
new file mode 100644
index 0000000..52e4e61
--- /dev/null
+++ b/scripts/gdb/linux/.gitignore
@@ -0,0 +1,2 @@
+*.pyc
+*.pyo
-- 
2.1.4

