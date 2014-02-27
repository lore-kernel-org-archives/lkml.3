Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446AbaB0QwH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 11:52:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:3958 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752966AbaB0QwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 11:52:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,555,1389772800"; 
   d="scan'208";a="490994029"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: [PATCH RESEND V3 2/2] x86: IOSF: Change IOSF_MBI Kconfig to default y
Date: Thu, 27 Feb 2014 08:50:21 -0800
Message-Id: <1393519821-17318-1-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393443617-8923-3-git-send-email-david.e.box@linux.intel.com>
References: <1393296442-12942-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

The IOSF Mailbox interface is an access mechanism used by drivers to communicate
with the configuration registers of devices connected on the fabric of Intel SOC
platforms. The interface is ubiquitous enough that we need to ensure the
availability of the driver in non-EXPERT configured x86 kernels. Make the module
built-in so drivers can access device registers that need configuration during
early boot.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d3b1f8b..4de5205 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2385,11 +2385,12 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config IOSF_MBI
-	bool
+	bool "IOSF MBI support" if EXPERT
+	default y
 	depends on PCI
 	---help---
 	  To be selected by modules requiring access to the Intel OnChip System
-	  Fabric (IOSF) Sideband MailBox Interface (MBI). For MBI platforms
+	  Fabric (IOSF) Sideband MailBox Interface (MBI). For IOSF platforms
 	  enumerable by PCI.
 
 source "net/Kconfig"
-- 
1.7.10.4

