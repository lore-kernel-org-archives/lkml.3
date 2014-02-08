Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131AbaBHIDh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:03:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:48866 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131AbaBHICN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:02:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="471776745"
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 07/17] Kbuild, lto, workaround: Don't warn for initcall_reference in modpost
Date: Sat,  8 Feb 2014 09:01:11 +0100
Message-Id: <1391846481-31491-7-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reference is discarded, but can cause warnings when it refers to
exit. Ignore for now.

This is a workaround and can be removed once we get rid of
-fno-toplevel-reorder

Signed-off-by: Andi Kleen <ak@linux.intel.com>
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
-- 
1.8.5.2

