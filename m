Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751522AbaELDbW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 23:31:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45079 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751004AbaELDbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 23:31:20 -0400
Date: Sun, 11 May 2014 20:30:58 -0700
From: "tip-bot for H. Peter Anvin" <tipbot@zytor.com>
Message-ID: <tip-7a5091d58419b4e5222abce58a40c072786ea1d6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        smueller@chronox.de, tglx@linutronix.de, tytso@mit.edu,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        smueller@chronox.de, tglx@linutronix.de, hpa@linux.intel.com,
        tytso@mit.edu
In-Reply-To: <21542339.0lFnPSyGRS@myon.chronox.de>
References: <21542339.0lFnPSyGRS@myon.chronox.de>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86, rdrand: When nordrand is specified,
  disable RDSEED as well
Git-Commit-ID: 7a5091d58419b4e5222abce58a40c072786ea1d6
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

Commit-ID:  7a5091d58419b4e5222abce58a40c072786ea1d6
Gitweb:     http://git.kernel.org/tip/7a5091d58419b4e5222abce58a40c072786ea1d6
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Sun, 11 May 2014 20:25:20 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Sun, 11 May 2014 20:25:20 -0700

x86, rdrand: When nordrand is specified, disable RDSEED as well

One can logically expect that when the user has specified "nordrand",
the user doesn't want any use of the CPU random number generator,
neither RDRAND nor RDSEED, so disable both.

Reported-by: Stephan Mueller <smueller@chronox.de>
Cc: Theodore Ts'o <tytso@mit.edu>
Link: http://lkml.kernel.org/r/21542339.0lFnPSyGRS@myon.chronox.de
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 Documentation/kernel-parameters.txt | 8 ++++----
 arch/x86/kernel/cpu/rdrand.c        | 1 +
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 4384217..30a8ad0d 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2218,10 +2218,10 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	noreplace-smp	[X86-32,SMP] Don't replace SMP instructions
 			with UP alternatives
 
-	nordrand	[X86] Disable the direct use of the RDRAND
-			instruction even if it is supported by the
-			processor.  RDRAND is still available to user
-			space applications.
+	nordrand	[X86] Disable kernel use of the RDRAND and
+			RDSEED instructions even if they are supported
+			by the processor.  RDRAND and RDSEED are still
+			available to user space applications.
 
 	noresume	[SWSUSP] Disables resume and restores original swap
 			space.
diff --git a/arch/x86/kernel/cpu/rdrand.c b/arch/x86/kernel/cpu/rdrand.c
index 384df51..136ac74 100644
--- a/arch/x86/kernel/cpu/rdrand.c
+++ b/arch/x86/kernel/cpu/rdrand.c
@@ -27,6 +27,7 @@
 static int __init x86_rdrand_setup(char *s)
 {
 	setup_clear_cpu_cap(X86_FEATURE_RDRAND);
+	setup_clear_cpu_cap(X86_FEATURE_RDSEED);
 	return 1;
 }
 __setup("nordrand", x86_rdrand_setup);
