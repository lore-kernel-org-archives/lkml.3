Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976AbbATLy7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:54:59 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56594 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120AbbATLy5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:54:57 -0500
Date: Tue, 20 Jan 2015 03:54:38 -0800
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-1b43d7125f3b6f7d46e72da64f65f3187a83b66b@git.kernel.org>
Cc: aubrey.li@linux.intel.com, mahesh.kumar.p@intel.com, tglx@linutronix.de,
        andriy.shevchenko@linux.intel.com, rafael.j.wysocki@intel.com,
        linux-kernel@vger.kernel.org, mingo@kernel.org, hpa@zytor.com
Reply-To: mahesh.kumar.p@intel.com, andriy.shevchenko@linux.intel.com,
        tglx@linutronix.de, aubrey.li@linux.intel.com,
        linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        rafael.j.wysocki@intel.com
In-Reply-To: <1421253575-22509-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421253575-22509-2-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: pmc-atom:
  Assign debugfs node as soon as possible
Git-Commit-ID: 1b43d7125f3b6f7d46e72da64f65f3187a83b66b
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

Commit-ID:  1b43d7125f3b6f7d46e72da64f65f3187a83b66b
Gitweb:     http://git.kernel.org/tip/1b43d7125f3b6f7d46e72da64f65f3187a83b66b
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Wed, 14 Jan 2015 18:39:31 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 12:50:14 +0100

x86: pmc-atom: Assign debugfs node as soon as possible

pmc_dbgfs_unregister() will be called when pmc->dbgfs_dir is unconditionally
NULL on error path in pmc_dbgfs_register(). To prevent this we move the
assignment to where is should be.

Fixes: f855911c1f48 (x86/pmc_atom: Expose PMC device state and platform sleep state)
Reported-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Kumar P. Mahesh <mahesh.kumar.p@intel.com>
Link: http://lkml.kernel.org/r/1421253575-22509-2-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/pmc_atom.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 0ee5025e..8bb9a61 100644
--- a/arch/x86/kernel/pmc_atom.c
+++ b/arch/x86/kernel/pmc_atom.c
@@ -217,6 +217,8 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
 	if (!dir)
 		return -ENOMEM;
 
+	pmc->dbgfs_dir = dir;
+
 	f = debugfs_create_file("dev_state", S_IFREG | S_IRUGO,
 				dir, pmc, &pmc_dev_state_ops);
 	if (!f) {
@@ -229,7 +231,7 @@ static int pmc_dbgfs_register(struct pmc_dev *pmc, struct pci_dev *pdev)
 		dev_err(&pdev->dev, "sleep_state register failed\n");
 		goto err;
 	}
-	pmc->dbgfs_dir = dir;
+
 	return 0;
 err:
 	pmc_dbgfs_unregister(pmc);
