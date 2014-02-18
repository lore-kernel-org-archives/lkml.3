Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755921AbaBROjL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:39:11 -0500
Received: from mga11.intel.com ([192.55.52.93]:60260 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755987AbaBRO3s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="483436691"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 08/20] Kbuild, lto, workaround: Don't warn for initcall_reference in modpost
Date: Tue, 18 Feb 2014 15:28:46 +0100
Message-Id: <1392733738-8290-9-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
References: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

This reference is discarded, but can cause warnings when it refers to
exit. Ignore for now.

This is a workaround and can be removed once we get rid of
-fno-toplevel-reorder

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/mod/modpost.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 4061098..bd06857 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1455,6 +1455,10 @@ static void check_section_mismatch(const char *modname, struct elf_info *elf,
 		to = find_elf_symbol(elf, r->r_addend, sym);
 		tosym = sym_name(elf, to);
 
+		if (!strncmp(fromsym, "reference___initcall",
+				sizeof("reference___initcall") - 1))
+			return;
+
 		/* check whitelist - we may ignore it */
 		if (secref_whitelist(mismatch,
 					fromsec, fromsym, tosec, tosym)) {
-- 
1.8.5.2

