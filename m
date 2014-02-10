Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722AbaBJNdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 08:33:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33306 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657AbaBJNdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 08:33:09 -0500
Date: Mon, 10 Feb 2014 05:31:57 -0800
From: tip-bot for Ingo Molnar <tipbot@zytor.com>
Message-ID: <tip-8c778d541bec8a41cbd8fa73b7cba90b2d6606c1@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org, richard@nod.at,
        bp@alien8.de, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        bp@suse.de, rientjes@google.com, paul.gortmaker@windriver.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        andi@firstfloor.org, torvalds@linux-foundation.org, richard@nod.at,
        bp@alien8.de, masami.hiramatsu.pt@hitachi.com, tglx@linutronix.de,
        rientjes@google.com, bp@suse.de, paul.gortmaker@windriver.com
In-Reply-To: <20140205055137.GB30094@gmail.com>
References: <20140205055137.GB30094@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/debug:
  Disable CONFIG_X86_DECODER_SELFTEST in allmod/allyesconfigs
Git-Commit-ID: 8c778d541bec8a41cbd8fa73b7cba90b2d6606c1
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 10 Feb 2014 05:32:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8c778d541bec8a41cbd8fa73b7cba90b2d6606c1
Gitweb:     http://git.kernel.org/tip/8c778d541bec8a41cbd8fa73b7cba90b2d6606c1
Author:     Ingo Molnar <mingo@kernel.org>
AuthorDate: Wed, 5 Feb 2014 06:51:37 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Sun, 9 Feb 2014 15:18:42 +0100

x86/debug: Disable CONFIG_X86_DECODER_SELFTEST in allmod/allyesconfigs

* Linus Torvalds <torvalds@linux-foundation.org> wrote:

Andi Kleen suggested to turn off CONFIG_X86_DECODER_SELFTEST=y
in allyesconfig, because it costs a lot of CPU time.

(In practice randconfig builds will cover this test frequently
 enough to provide build coverage.)

Suggested-by: Andi Kleen <andi@firstfloor.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Richard Weinberger <richard@nod.at>
Cc: Borislav Petkov <bp@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140205055137.GB30094@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/Kconfig.debug | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 321a52c..b542ec1 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -185,6 +185,11 @@ config X86_DECODER_SELFTEST
 	bool "x86 instruction decoder selftest"
 	depends on DEBUG_KERNEL && KPROBES
 	depends on !COMPILE_TEST
+	#
+	# It can take some time to validate the image,
+	# make sure {allyes|allmod}config doesn't enable it:
+	#
+	depends on !COMPILE_TEST
 	---help---
 	 Perform x86 instruction decoder selftests at build time.
 	 This option is useful for checking the sanity of x86 instruction
