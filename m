Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbaLWMDN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 07:03:13 -0500
Received: from canardo.mork.no ([148.122.252.1]:47284 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756095AbaLWMDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 07:03:11 -0500
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: x86@kernel.org
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH] x86: clean auto-generated processor feature files
Date: Tue, 23 Dec 2014 12:57:43 +0100
Message-Id: <1419335863-10608-1-git-send-email-bjorn@mork.no>
X-Mailer: git-send-email 2.1.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.3.9 (canardo.mork.no [IPv6:::1]); Tue, 23 Dec 2014 13:01:47 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 9def39be4e96 ("x86: Support compiling out human-friendly
processor feature names") made two source file targets conditional.
Such conditional targets will not be cleaned automatically by make
mrproper.

Fix by adding explicit clean-files targets for the two files.

Fixes: 9def39be4e96 ("x86: Support compiling out human-friendly processor feature names")
Cc: Josh Triplett <josh@joshtriplett.org>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
---
 arch/x86/boot/Makefile       | 1 +
 arch/x86/kernel/cpu/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 5b016e2498f3..3db07f30636f 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -51,6 +51,7 @@ targets += cpustr.h
 $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 	$(call if_changed,cpustr)
 endif
+clean-files += cpustr.h
 
 # ---------------------------------------------------------------------------
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index e27b49d7c922..80091ae54c2b 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -66,3 +66,4 @@ targets += capflags.c
 $(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
 	$(call if_changed,mkcapflags)
 endif
+clean-files += capflags.c
-- 
2.1.3

