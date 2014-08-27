Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935990AbaH0Vnp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 17:43:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:63868 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935773AbaH0VnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 17:43:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,414,1406617200"; 
   d="scan'208";a="594222536"
From: "David E. Box" <david.e.box@linux.intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, alan@linux.intel.com
Subject: [PATCH 1/2] x86: iosf: Add Kconfig prompt for IOSF_MBI selection
Date: Wed, 27 Aug 2014 14:40:39 -0700
Message-Id: <1409175640-32426-2-git-send-email-david.e.box@linux.intel.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
References: <1409175640-32426-1-git-send-email-david.e.box@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes an error in having the iosf build as 'default m'. On X86 SoC's the iosf
sideband is the only way to access information for some registers, as opposed to
through MSR's on other Intel architectures. While selecting IOSF_MBI is
preferred, it does mean carrying extra code on non-SoC architectures. This
exports the selection to the user, allowing those driver writers to compile out
iosf code if it's not being built.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
---
 arch/x86/Kconfig | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index d24887b..e07e2a5 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2400,9 +2400,19 @@ config X86_DMA_REMAP
 	depends on STA2X11
 
 config IOSF_MBI
-	tristate
-	default m
+	tristate "Intel System On Chip IOSF Sideband support"
 	depends on PCI
+	---help---
+	  Enables sideband access to mailbox registers on SoC's. The sideband is
+	  available on the following platforms. This list is not meant to be
+	  exclusive.
+	   - BayTrail
+	   - Cherryview
+	   - Braswell
+	   - Quark
+
+	  You should say Y if you are running a kernel on one of these
+	  platforms.
 
 source "net/Kconfig"
 
-- 
1.9.1

