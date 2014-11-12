Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaKLRUa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 12:20:30 -0500
Received: from mga02.intel.com ([134.134.136.20]:21765 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbaKLRUJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 12:20:09 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,370,1413270000"; 
   d="scan'208";a="635843908"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: "H . Peter Anvin" <hpa@linux.intel.com>, x86@kernel.org,
        Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v4 2/3] x86: pmc_atom: don't check for NULL twice
Date: Wed, 12 Nov 2014 19:18:08 +0200
Message-Id: <1415812689-17326-3-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415812689-17326-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1415812689-17326-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

debugfs_remove_recursive() is NULL-aware, thus, we may safely remove the check
here. There is no need to assing NULL to variable since it will be not used
anywhere.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
---
 arch/x86/kernel/pmc_atom.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 19b8efa..bcc91ea 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -202,11 +202,7 @@ static const struct file_operations pmc_sleep_tmr_ops = {
 
 static void pmc_dbgfs_unregister(struct pmc_dev *pmc)
 {
-	if (!pmc->dbgfs_dir)
-		return;
-
 	debugfs_remove_recursive(pmc->dbgfs_dir);
-	pmc->dbgfs_dir = NULL;
 }
 
 static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
-- 
2.1.3

