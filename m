Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935422AbaH0PYP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 11:24:15 -0400
Received: from thoth.sbs.de ([192.35.17.2]:40373 "EHLO thoth.sbs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935307AbaH0PWe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 11:22:34 -0400
From: Jan Kiszka <jan.kiszka@siemens.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Cc: Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Andi Kleen <andi@firstfloor.org>,
        Tom Tromey <tromey@redhat.com>, Ben Widawsky <ben@bwidawsk.net>,
        Borislav Petkov <bp@suse.de>,
        Tatiana Al-Chueyr Martins <tatiana.alchueyr@gmail.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH v9 23/23] scripts/gdb: Ignore byte-compiled python files
Date: Wed, 27 Aug 2014 17:21:38 +0200
Message-Id: <0cd72dfec1784fa6ec081144467fd8b9f07ed300.1409152897.git.jan.kiszka@siemens.com>
X-Mailer: git-send-email 1.8.1.1.298.ge7eed54
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1409152897.git.jan.kiszka@siemens.com>
References: <cover.1409152897.git.jan.kiszka@siemens.com>
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
 Makefile                     | 2 +-
 scripts/gdb/linux/.gitignore | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 scripts/gdb/linux/.gitignore

diff --git a/.gitignore b/.gitignore
index e213b27..17d4457 100644
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
index 6cddc6f..d319e25 100644
--- a/Makefile
+++ b/Makefile
@@ -1171,7 +1171,7 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
 		  signing_key.priv signing_key.x509 x509.genkey		\
 		  extra_certificates signing_key.x509.keyid		\
 		  signing_key.x509.signer include/linux/version.h	\
-		  vmlinux-gdb.py
+		  vmlinux-gdb.py scripts/gdb/linux/*.py[co]
 
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
1.8.1.1.298.ge7eed54

