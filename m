Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756AbaHFO2M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 10:28:12 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:51133 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbaHFO2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 10:28:08 -0400
From: Daniel Thompson <daniel.thompson@linaro.org>
To: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Daniel Thompson <daniel.thompson@linaro.org>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: [PATCH gdb/scripts] scripts/gdb: Ignore byte-compiled python files
Date: Wed,  6 Aug 2014 15:27:49 +0100
Message-Id: <1407335269-9533-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: git-send-email 1.9.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using the gdb scripts leaves byte-compiled python files in the scripts/
directory. These should be ignored by git and cleaned up by mrproper.

Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org
---

Notes:
    Relies upon (and intended for incorporation into) Jan Kiszka's gdb/scripts
    patch series.

 .gitignore                   | 1 +
 Makefile                     | 2 +-
 scripts/gdb/linux/.gitignore | 2 ++
 3 files changed, 4 insertions(+), 1 deletion(-)
 create mode 100644 scripts/gdb/linux/.gitignore

diff --git a/.gitignore b/.gitignore
index f4c0b09..a04486e 100644
--- a/.gitignore
+++ b/.gitignore
@@ -42,6 +42,7 @@ Module.symvers
 /TAGS
 /linux
 /vmlinux
+/vmlinux-gdb.py
 /vmlinuz
 /System.map
 /Module.markers
diff --git a/Makefile b/Makefile
index 7105eb2a..a3ca8ba 100644
--- a/Makefile
+++ b/Makefile
@@ -1136,7 +1136,7 @@ MRPROPER_FILES += .config .config.old .version .old_version $(version_h) \
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
1.9.3

