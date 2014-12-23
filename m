Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221AbaLWOkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 09:40:07 -0500
Received: from terminus.zytor.com ([198.137.202.10]:39632 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910AbaLWOkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 09:40:05 -0500
Date: Tue, 23 Dec 2014 06:39:31 -0800
From: "=?UTF-8?B?dGlwLWJvdCBmb3IgQmrDuHJuIE1vcms=?=" <tipbot@zytor.com>
Message-ID: <tip-280dbc572357eb50184663fc9e4aaf09c8141e9b@git.kernel.org>
Cc: hpa@zytor.com, bjorn@mork.no, josh@joshtriplett.org, tglx@linutronix.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org
Reply-To: tglx@linutronix.de, mingo@kernel.org, linux-kernel@vger.kernel.org,
        bjorn@mork.no, hpa@zytor.com, josh@joshtriplett.org
In-Reply-To: <1419335863-10608-1-git-send-email-bjorn@mork.no>
References: <1419335863-10608-1-git-send-email-bjorn@mork.no>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/build:
  Clean auto-generated processor feature files
Git-Commit-ID: 280dbc572357eb50184663fc9e4aaf09c8141e9b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  280dbc572357eb50184663fc9e4aaf09c8141e9b
Gitweb:     http://git.kernel.org/tip/280dbc572357eb50184663fc9e4aaf09c8141e9b
Author:     Bjørn Mork <bjorn@mork.no>
AuthorDate: Tue, 23 Dec 2014 12:57:43 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 23 Dec 2014 15:37:06 +0100

x86/build: Clean auto-generated processor feature files

Commit 9def39be4e96 ("x86: Support compiling out human-friendly
processor feature names") made two source file targets
conditional. Such conditional targets will not be cleaned
automatically by make mrproper.

Fix by adding explicit clean-files targets for the two files.

Fixes: 9def39be4e96 ("x86: Support compiling out human-friendly processor feature names")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Cc: Josh Triplett <josh@joshtriplett.org>
Link: http://lkml.kernel.org/r/1419335863-10608-1-git-send-email-bjorn@mork.no
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/boot/Makefile       | 1 +
 arch/x86/kernel/cpu/Makefile | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 5b016e2..3db07f3 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -51,6 +51,7 @@ targets += cpustr.h
 $(obj)/cpustr.h: $(obj)/mkcpustr FORCE
 	$(call if_changed,cpustr)
 endif
+clean-files += cpustr.h
 
 # ---------------------------------------------------------------------------
 
diff --git a/arch/x86/kernel/cpu/Makefile b/arch/x86/kernel/cpu/Makefile
index e27b49d..80091ae 100644
--- a/arch/x86/kernel/cpu/Makefile
+++ b/arch/x86/kernel/cpu/Makefile
@@ -66,3 +66,4 @@ targets += capflags.c
 $(obj)/capflags.c: $(cpufeature) $(src)/mkcapflags.sh FORCE
 	$(call if_changed,mkcapflags)
 endif
+clean-files += capflags.c
