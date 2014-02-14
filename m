Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752449AbaBNEcU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:32:20 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48206 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752395AbaBNEcQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:32:16 -0500
Date: Thu, 13 Feb 2014 20:32:06 -0800
From: tip-bot for Andi Kleen <tipbot@zytor.com>
Message-ID: <tip-1e64ff42ea3d8d2fc8aa71f9717b3c1cb6c2f893@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ak@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1391846481-31491-11-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-11-git-send-email-ak@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/asmlinkage] Kbuild, lto: Disable LTO for asm-offsets.c
Git-Commit-ID: 1e64ff42ea3d8d2fc8aa71f9717b3c1cb6c2f893
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 13 Feb 2014 20:32:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1e64ff42ea3d8d2fc8aa71f9717b3c1cb6c2f893
Gitweb:     http://git.kernel.org/tip/1e64ff42ea3d8d2fc8aa71f9717b3c1cb6c2f893
Author:     Andi Kleen <ak@linux.intel.com>
AuthorDate: Sat, 8 Feb 2014 09:01:15 +0100
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 13 Feb 2014 20:25:03 -0800

Kbuild, lto: Disable LTO for asm-offsets.c

The asm-offset.c technique to fish data out of the assembler file
does not work with LTO. Just disable for the asm-offset.c build.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Link: http://lkml.kernel.org/r/1391846481-31491-11-git-send-email-ak@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 scripts/Makefile.build | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index d5d859c..9f0ee22 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -198,7 +198,7 @@ $(multi-objs-y:.o=.s)   : modname = $(modname-multi)
 $(multi-objs-y:.o=.lst) : modname = $(modname-multi)
 
 quiet_cmd_cc_s_c = CC $(quiet_modtag)  $@
-cmd_cc_s_c       = $(CC) $(c_flags) -fverbose-asm -S -o $@ $<
+cmd_cc_s_c       = $(CC) $(c_flags) $(DISABLE_LTO) -fverbose-asm -S -o $@ $<
 
 $(obj)/%.s: $(src)/%.c FORCE
 	$(call if_changed_dep,cc_s_c)
