Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934560AbaKLBnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:43:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60450 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934541AbaKLBn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:43:28 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ong Boon Leong <boon.leong.ong@intel.com>,
        "David E. Box" <david.e.box@linux.intel.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Subject: [PATCH 3.14 116/203] x86, iosf: Add PCI ID macros for better readability
Date: Wed, 12 Nov 2014 10:16:26 +0900
Message-Id: <20141112011548.000007869@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011542.686743533@linuxfoundation.org>
References: <20141112011542.686743533@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ong Boon Leong <boon.leong.ong@intel.com>

commit 04725ad59474d24553d526fa774179ecd2922342 upstream.

Introduce PCI IDs macro for the list of supported product:
BayTrail & Quark X1000.

Signed-off-by: Ong Boon Leong <boon.leong.ong@intel.com>
Link: http://lkml.kernel.org/r/1399668248-24199-5-git-send-email-david.e.box@linux.intel.com
Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Chang Rebecca Swee Fun <rebecca.swee.fun.chang@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/iosf_mbi.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/iosf_mbi.c
+++ b/arch/x86/kernel/iosf_mbi.c
@@ -25,6 +25,9 @@
 
 #include <asm/iosf_mbi.h>
 
+#define PCI_DEVICE_ID_BAYTRAIL		0x0F00
+#define PCI_DEVICE_ID_QUARK_X1000	0x0958
+
 static DEFINE_SPINLOCK(iosf_mbi_lock);
 
 static inline u32 iosf_mbi_form_mcr(u8 op, u8 port, u8 offset)
@@ -200,8 +203,8 @@ static int iosf_mbi_probe(struct pci_dev
 }
 
 static DEFINE_PCI_DEVICE_TABLE(iosf_mbi_pci_ids) = {
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0F00) },
-	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, 0x0958) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_BAYTRAIL) },
+	{ PCI_DEVICE(PCI_VENDOR_ID_INTEL, PCI_DEVICE_ID_QUARK_X1000) },
 	{ 0, },
 };
 MODULE_DEVICE_TABLE(pci, iosf_mbi_pci_ids);


