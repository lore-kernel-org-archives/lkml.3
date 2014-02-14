Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265AbaBNVWg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:22:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:7228 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753245AbaBNVWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:22:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="483680397"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz,
        Andi Kleen <ak@linux.intel.com>, rusty@rustcorp.com.au
Subject: [PATCH 18/19] lto, module: Warn about modules that are not fully LTOed
Date: Fri, 14 Feb 2014 22:21:42 +0100
Message-Id: <1392412903-25733-19-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
References: <1392412903-25733-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When __gnu_lto_* is present that means that the module hasn't run with
LTO yet.

Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/module.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index b99e801..4f3eff7 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1949,8 +1949,11 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 		switch (sym[i].st_shndx) {
 		case SHN_COMMON:
 			/* Ignore common symbols */
-			if (!strncmp(name, "__gnu_lto", 9))
+			if (!strncmp(name, "__gnu_lto", 9)) {
+				pr_info("%s: module not link time optimized\n",
+				       mod->name);
 				break;
+			}
 
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
-- 
1.8.5.2

