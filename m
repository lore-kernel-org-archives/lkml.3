Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755237AbaE2BoW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 21:44:22 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:41078 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755059AbaE2BoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 21:44:12 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: Andy Lutomirski <luto@amacapital.net>, Philipp Kern <pkern@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, linux-kernel@vger.kernel.org,
        "H. J. Lu" <hjl.tools@gmail.com>, Eric Paris <eparis@redhat.com>,
        security@kernel.org, greg@kroah.com, linux-audit@redhat.com
Subject: [PATCH v2 2/2] audit: Mark CONFIG_AUDITSYSCALL BROKEN and update help text
Date: Wed, 28 May 2014 18:44:01 -0700
Message-Id: <ff8ecb985119c06510e2c45c078b41cd5df3aaea.1401327752.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <cover.1401327752.git.luto@amacapital.net>
References: <cover.1401327752.git.luto@amacapital.net>
In-Reply-To: <cover.1401327752.git.luto@amacapital.net>
References: <cover.1401327752.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here are some issues with the code:
 - It thinks that syscalls have four arguments.
 - It's a performance disaster.
 - It assumes that syscall numbers are between 0 and 2048.
 - It's unclear whether it's supposed to be reliable.
 - It's broken on things like x32.
 - It can't support ARM OABI.
 - Its approach to freeing memory is terrifying.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 init/Kconfig | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index 9d3585b..24d4b53 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -296,13 +296,16 @@ config HAVE_ARCH_AUDITSYSCALL
 	bool
 
 config AUDITSYSCALL
-	bool "Enable system-call auditing support"
-	depends on AUDIT && HAVE_ARCH_AUDITSYSCALL
+	bool "Enable system-call auditing support (not recommended)"
+	depends on AUDIT && HAVE_ARCH_AUDITSYSCALL && BROKEN
 	default y if SECURITY_SELINUX
 	help
-	  Enable low-overhead system-call auditing infrastructure that
-	  can be used independently or with another kernel subsystem,
-	  such as SELinux.
+	  Enable system-call auditing infrastructure that can be used
+	  independently or with another kernel subsystem, such as
+	  SELinux.
+
+	  AUDITSYSCALL has serious performance and correctness issues.
+	  Use it with extreme caution.
 
 config AUDIT_WATCH
 	def_bool y
-- 
1.9.3

