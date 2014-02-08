Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaBHIEe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 03:04:34 -0500
Received: from mga02.intel.com ([134.134.136.20]:59594 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734AbaBHICL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 03:02:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,805,1384329600"; 
   d="scan'208";a="480010877"
From: Andi Kleen <ak@linux.intel.com>
To: linux-kernel@vger.kernel.org
Cc: linux-kbuild@vger.kernel.org, x86@kernel.org,
        Andi Kleen <ak@linux.intel.com>, rusty@rustcorp.com.au
Subject: [PATCH 17/17] lto, module: Warn about modules that are not fully LTOed
Date: Sat,  8 Feb 2014 09:01:21 +0100
Message-Id: <1391846481-31491-17-git-send-email-ak@linux.intel.com>
X-Mailer: git-send-email 1.8.5.2
In-Reply-To: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When __gnu_lto_* is present that means that the module hasn't run with
LTO yet.

Cc: rusty@rustcorp.com.au
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 kernel/module.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/module.c b/kernel/module.c
index b99e801..2052155 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -1949,8 +1949,11 @@ static int simplify_symbols(struct module *mod, const struct load_info *info)
 		switch (sym[i].st_shndx) {
 		case SHN_COMMON:
 			/* Ignore common symbols */
-			if (!strncmp(name, "__gnu_lto", 9))
+			if (!strncmp(name, "__gnu_lto", 9)) {
+				printk("%s: module not link time optimized\n",
+				       mod->name);
 				break;
+			}
 
 			/* We compiled with -fno-common.  These are not
 			   supposed to happen.  */
-- 
1.8.5.2

