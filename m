Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126AbbANQks (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 11:40:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:31861 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972AbbANQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 11:39:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,756,1413270000"; 
   d="scan'208";a="651077353"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: x86@kernel.org, Aubrey Li <aubrey.li@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        "Kumar P, Mahesh" <mahesh.kumar.p@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH v5 4/5] x86: pmc_atom: clean up init function
Date: Wed, 14 Jan 2015 18:39:34 +0200
Message-Id: <1421253575-22509-5-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1421253575-22509-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421253575-22509-1-git-send-email-andriy.shevchenko@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no need to use err variable.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
---
 arch/x86/kernel/pmc_atom.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 6b62f55..f8becc4 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -288,7 +288,6 @@ MODULE_DEVICE_TABLE(pci, pmc_pci_ids);
 
 static int __init pmc_atom_init(void)
 {
-	int err = -ENODEV;
 	struct pci_dev *pdev = NULL;
 	const struct pci_device_id *ent;
 
@@ -302,14 +301,11 @@ static int __init pmc_atom_init(void)
 	 */
 	for_each_pci_dev(pdev) {
 		ent = pci_match_id(pmc_pci_ids, pdev);
-		if (ent) {
-			err = pmc_setup_dev(pdev);
-			goto out;
-		}
+		if (ent)
+			return pmc_setup_dev(pdev);
 	}
 	/* Device not found. */
-out:
-	return err;
+	return -ENODEV;
 }
 
 module_init(pmc_atom_init);
-- 
2.1.4

