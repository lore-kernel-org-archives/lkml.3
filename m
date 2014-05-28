Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540AbaE1VZ3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:25:29 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42011 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaE1VZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:25:26 -0400
Date: Wed, 28 May 2014 14:25:15 -0700
From: tip-bot for Ong Boon Leong <tipbot@zytor.com>
Message-ID: <tip-04725ad59474d24553d526fa774179ecd2922342@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        boon.leong.ong@intel.com, david.e.box@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        boon.leong.ong@intel.com, david.e.box@linux.intel.com,
        tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1399668248-24199-5-git-send-email-david.e.box@linux.intel.com>
References: <1399668248-24199-5-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, iosf:
  Add PCI ID macros for better readability
Git-Commit-ID: 04725ad59474d24553d526fa774179ecd2922342
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

Commit-ID:  04725ad59474d24553d526fa774179ecd2922342
Gitweb:     http://git.kernel.org/tip/04725ad59474d24553d526fa774179ecd2922342
Author:     Ong Boon Leong <boon.leong.ong@intel.com>
AuthorDate: Fri, 9 May 2014 13:44:08 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 9 May 2014 14:57:35 -0700

x86, iosf: Add PCI ID macros for better readability

Introduce PCI IDs macro for the list of supported product:
BayTrail & Quark X1000.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Link: http://lkml.kernel.org/r/1399668248-24199-5-git-send-email-david.e.box@linux.intel.com
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/iosf_mbi.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/iosf_mbi.c b/arch/x86/kernel/iosf_mbi.c
index 201a7ab..d30acdc 100644
--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -25,6 +25,9 @@
 
 #include <asm/iosf_mbi.h>
 
+#define PCI_DEVICE_ID_BAYTRAIL		0x0F00
+#define PCI_DEVICE_ID_QUARK_X1000	0x0958
+
 static DEFINE_SPINLOCK(iosf_mbi_lock);
 
 static inline u32 iosf_mbi_form_mcr(u8 op, u8 port, u8 offset)
@@ -200,8 +203,8 @@ static int iosf_mbi_probe(struct pci_dev *pdev,
 }
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0958) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BAYTRAIL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_QUARK_X1000) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);
