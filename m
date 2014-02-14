Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752334AbaBNEb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:31:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48193 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293AbaBNEbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:31:55 -0500
Date: Thu, 13 Feb 2014 20:31:45 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-ccbef1674a1579842c7dbdf554efca85d2cd245a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391846481-31491-9-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-9-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] Kbuild, lto:
  add ld-version and ld-ifversion macros
Git-Commit-ID: ccbef1674a1579842c7dbdf554efca85d2cd245a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:31:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ccbef1674a1579842c7dbdf554efca85d2cd245a
Gitweb:     http://git.kernel.org/tip/ccbef1674a1579842c7dbdf554efca85d2cd245a
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:13 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:25:00 -0800

Kbuild, lto: add ld-version and ld-ifversion macros

To check the linker version. Used by the LTO makefile.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-9-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/Kbuild.include | 9 +++++++++
 scripts/ld-version.sh  | 8 ++++++++
 2 files changed, 17 insertions(+)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 547e15d..93a0da2 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -155,6 +155,15 @@ ld-option = $(call try-run,\
 # Important: no spaces around options
 ar-option = $(call try-run, $(AR) rc$(1) "$$TMP",$(1),$(2))
 
+# ld-version
+# Usage: $(call ld-version)
+# Note this is mainly for HJ Lu's 3 number binutil versions
+ld-version = $(shell $(LD) --version | $(srctree)/scripts/ld-version.sh)
+
+# ld-ifversion
+# Usage:  $(call ld-ifversion, -ge, 22252, y)
+ld-ifversion = $(shell [ $(call ld-version) $(1) $(2) ] && echo $(3))
+
 ######
 
 ###
diff --git a/scripts/ld-version.sh b/scripts/ld-version.sh
new file mode 100755
index 0000000..198580d
--- /dev/null
+++ b/scripts/ld-version.sh
@@ -0,0 +1,8 @@
+#!/usr/bin/awk -f
+# extract linker version number from stdin and turn into single number
+	{
+	gsub(".*)", "");
+	split($1,a, ".");
+	print a[1]*10000000 + a[2]*100000 + a[3]*10000 + a[4]*100 + a[5];
+	exit
+	}
