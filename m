Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150AbbATLz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:55:58 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56633 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498AbbATLz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:55:56 -0500
Date: Tue, 20 Jan 2015 03:55:45 -0800
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-4b25f42a371b16807f0966490f8faad9abc712d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        tglx@linutronix.de, aubrey.li@linux.intel.com, mingo@kernel.org,
        mahesh.kumar.p@intel.com, andriy.shevchenko@linux.intel.com,
        hpa@zytor.com
Reply-To: rafael.j.wysocki@intel.com, aubrey.li@linux.intel.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, hpa@zytor.com,
        mahesh.kumar.p@intel.com, mingo@kernel.org
In-Reply-To: <1421253575-22509-5-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421253575-22509-5-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: pmc_atom: Clean up init function
Git-Commit-ID: 4b25f42a371b16807f0966490f8faad9abc712d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4b25f42a371b16807f0966490f8faad9abc712d9
Gitweb:     http://git.kernel.org/tip/4b25f42a371b16807f0966490f8faad9abc712d9
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Wed, 14 Jan 2015 18:39:34 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 12:50:14 +0100

x86: pmc_atom: Clean up init function

There is no need to use err variable.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Kumar P. Mahesh <mahesh.kumar.p@intel.com>
Link: http://lkml.kernel.org/r/1421253575-22509-5-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
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
