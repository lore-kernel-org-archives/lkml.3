Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972AbaBYCtH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 21:49:07 -0500
Received: from mga02.intel.com ([134.134.136.20]:60535 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837AbaBYCtD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 21:49:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,538,1389772800"; 
   d="scan'208";a="489216080"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: "David E. Box" <david.e.box@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: [PATCH V2 2/2] x86: IOSF: Change IOSF_MBI Kconfig to default y
Date: Mon, 24 Feb 2014 18:47:22 -0800
Message-Id: <1393296442-12942-3-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1393296442-12942-1-git-send-email-david.e.box@linux.intel.com>
References: <1393296442-12942-1-git-send-email-david.e.box@linux.intel.com>
In-Reply-To: <1393117352-23717-1-git-send-email-david.e.box@linux.intel.com>
References: <1393117352-23717-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David E. Box" <david.e.box@linux.intel.com>

The IOSF Mailbox interface is an access mechanism used by multiple drivers to
communicate with key configuration registers on new Intel SOC platforms. The
interface is ubiquitous enough that we need to ensure the availability of the
driver in non-EXPERT x86 kernels.

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

