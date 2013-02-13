Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759312Ab3BMADf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:03:35 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58484 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759257Ab3BMADd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:03:33 -0500
Date: Tue, 12 Feb 2013 16:01:58 -0800
From: "tip-bot for H. Peter Anvin" <hpa@linux.intel.com>
Message-ID: <tip-ff52c3b02b3f73178bfe0c219cd22abdcb0e46c3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, jamie@shareable.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jamie@shareable.org, torvalds@linux-foundation.org,
        ville.syrjala@linux.intel.com, bp@alien8.de, linux@arm.linux.org.uk,
        tglx@linutronix.de, hpa@linux.intel.com, hjl.tools@gmail.com
In-Reply-To: <511ACDFB.1050707@zytor.com>
References: <511ACDFB.1050707@zytor.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, doc: Clarify the use of asm("%edx")
  in uaccess.h
Git-Commit-ID: ff52c3b02b3f73178bfe0c219cd22abdcb0e46c3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 12 Feb 2013 16:02:04 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  ff52c3b02b3f73178bfe0c219cd22abdcb0e46c3
Gitweb:     http://git.kernel.org/tip/ff52c3b02b3f73178bfe0c219cd22abdcb0e46c3
Author:     H. Peter Anvin <hpa@linux.intel.com>
AuthorDate: Tue, 12 Feb 2013 15:37:02 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 12 Feb 2013 15:37:02 -0800

x86, doc: Clarify the use of asm("%edx") in uaccess.h

Put in a comment that explains that the use of asm("%edx") in
uaccess.h doesn't actually necessarily mean %edx alone.

Cc: Jamie Lokier <jamie@shareable.org>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: H. J. Lu <hjl.tools@gmail.com>
Link: http://lkml.kernel.org/r/511ACDFB.1050707@zytor.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/uaccess.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index d710a25..5ee2687 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -148,9 +148,16 @@ __typeof__(__builtin_choose_expr(sizeof(x) > sizeof(0UL), 0ULL, 0UL))
  *
  * Returns zero on success, or -EFAULT on error.
  * On error, the variable @x is set to zero.
- *
+ */
+/*
  * Careful: we have to cast the result to the type of the pointer
  * for sign reasons.
+ *
+ * The use of %edx as the register specifier is a bit of a
+ * simplification, as gcc only cares about it as the starting point
+ * and not size: for a 64-bit value it will use %ecx:%edx on 32 bits
+ * (%ecx being the next register in gcc's x86 register sequence), and
+ * %rdx on 64 bits.
  */
 #define get_user(x, ptr)						\
 ({									\
