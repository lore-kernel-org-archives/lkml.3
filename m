Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757166Ab3JRAeI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 20:34:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50168 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062Ab3JRAeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 20:34:04 -0400
Date: Thu, 17 Oct 2013 17:33:54 -0700
From: tip-bot for Fengguang Wu <tipbot@zytor.com>
Message-ID: <tip-6c21b176a93ffaa8023555107167379ccdc6b71f@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com,
        sathyanarayanan.kuppuswamy@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sathyanarayanan.kuppuswamy@linux.intel.com,
        david.a.cohen@linux.intel.com, tglx@linutronix.de,
        fengguang.wu@intel.com, hpa@linux.intel.com
In-Reply-To: <1382049336-21316-5-git-send-email-david.a.cohen@linux.intel.com>
References: <1382049336-21316-5-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] pci: intel_mid: Return true/
 false in function returning bool
Git-Commit-ID: 6c21b176a93ffaa8023555107167379ccdc6b71f
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 17 Oct 2013 17:34:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6c21b176a93ffaa8023555107167379ccdc6b71f
Gitweb:     http://git.kernel.org/tip/6c21b176a93ffaa8023555107167379ccdc6b71f
Author:     Fengguang Wu <fengguang.wu@intel.com>
AuthorDate: Thu, 17 Oct 2013 15:35:28 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Thu, 17 Oct 2013 16:40:45 -0700

pci: intel_mid: Return true/false in function returning bool

Function 'type1_access_ok' should return bool value, not 0/1.
This patch changes 'return 0/1' to 'return false/true'.

Cc: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: David Cohen <david.a.cohen@linux.intel.com>
Signed-off-by: Fengguang Wu <fengguang.wu@intel.com>
Link: http://lkml.kernel.org/r/1382049336-21316-5-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/pci/intel_mid_pci.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/pci/intel_mid_pci.c b/arch/x86/pci/intel_mid_pci.c
index f8715f7..c5ca5b9 100644
--- a/arch/x86/pci/intel_mid_pci.c
+++ b/arch/x86/pci/intel_mid_pci.c
@@ -150,12 +150,12 @@ static bool type1_access_ok(unsigned int bus, unsigned int devfn, int reg)
 	 * shim. Therefore, use the header type in shim instead.
 	 */
 	if (reg >= 0x100 || reg == PCI_STATUS || reg == PCI_HEADER_TYPE)
-		return 0;
+		return false;
 	if (bus == 0 && (devfn == PCI_DEVFN(2, 0)
 				|| devfn == PCI_DEVFN(0, 0)
 				|| devfn == PCI_DEVFN(3, 0)))
-		return 1;
-	return 0; /* Langwell on others */
+		return true;
+	return false; /* Langwell on others */
 }
 
 static int pci_read(struct pci_bus *bus, unsigned int devfn, int where,
