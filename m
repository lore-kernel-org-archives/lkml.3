Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbbATLzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:55:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56614 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753757AbbATLzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:55:14 -0500
Date: Tue, 20 Jan 2015 03:55:03 -0800
From: tip-bot for Andy Shevchenko <tipbot@zytor.com>
Message-ID: <tip-d5df8fe34bec4539e259525feabd16efccf16750@git.kernel.org>
Cc: hpa@zytor.com, andriy.shevchenko@linux.intel.com,
        linux-kernel@vger.kernel.org, rafael.j.wysocki@intel.com,
        tglx@linutronix.de, mingo@kernel.org, aubrey.li@linux.intel.com,
        mahesh.kumar.p@intel.com
Reply-To: hpa@zytor.com, rafael.j.wysocki@intel.com, tglx@linutronix.de,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        andriy.shevchenko@linux.intel.com, aubrey.li@linux.intel.com,
        mahesh.kumar.p@intel.com
In-Reply-To: <1421253575-22509-3-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1421253575-22509-3-git-send-email-andriy.shevchenko@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86: pmc_atom: don%27t check for NULL twice
Git-Commit-ID: d5df8fe34bec4539e259525feabd16efccf16750
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

Commit-ID:  d5df8fe34bec4539e259525feabd16efccf16750
Gitweb:     http://git.kernel.org/tip/d5df8fe34bec4539e259525feabd16efccf16750
Author:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
AuthorDate: Wed, 14 Jan 2015 18:39:32 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 20 Jan 2015 12:50:14 +0100

x86: pmc_atom: don%27t check for NULL twice

debugfs_remove_recursive() is NULL-aware, thus, we may safely remove the check
here. There is no need to assing NULL to variable since it will be not used
anywhere.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Acked-by: Aubrey Li <aubrey.li@linux.intel.com>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Kumar P. Mahesh <mahesh.kumar.p@intel.com>
Link: http://lkml.kernel.org/r/1421253575-22509-3-git-send-email-andriy.shevchenko@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/kernel/pmc_atom.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kernel/pmc_atom.c b/arch/x86/kernel/pmc_atom.c
index 8bb9a61..1dd6c62 100644
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
