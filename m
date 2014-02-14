Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752214AbaBNEbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:31:33 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48177 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaBNEba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:31:30 -0500
Date: Thu, 13 Feb 2014 20:31:20 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-77ab21adae509c5540956729e2d03bc1a59bc82a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391846481-31491-7-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-7-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] Kbuild, lto, workaround: Don'
 t warn for initcall_reference in modpost
Git-Commit-ID: 77ab21adae509c5540956729e2d03bc1a59bc82a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:31:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  77ab21adae509c5540956729e2d03bc1a59bc82a
Gitweb:     http://git.kernel.org/tip/77ab21adae509c5540956729e2d03bc1a59bc82a
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:11 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:24:56 -0800

Kbuild, lto, workaround: Don't warn for initcall_reference in modpost

This reference is discarded, but can cause warnings when it refers to
exit. Ignore for now.

This is a workaround and can be removed once we get rid of
-fno-toplevel-reorder

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-7-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/mod/modpost.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 4061098..1f1b154 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1455,6 +1455,10 @@ static void check_section_mismatch(const char *modname, struct elf_info *elf,
 		to = find_elf_symbol(elf, r->r_addend, sym);
 		tosym = sym_name(elf, to);
 
+		if (!strncmp(fromsym, "reference___initcall",
+				sizeof("reference___initcall")-1))
+			return;
+
 		/* check whitelist - we may ignore it */
 		if (secref_whitelist(mismatch,
 					fromsec, fromsym, tosec, tosym)) {
