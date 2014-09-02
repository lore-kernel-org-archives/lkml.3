Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295AbaIBVIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 17:08:01 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39914 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753710AbaIBVH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 17:07:58 -0400
Date: Tue, 2 Sep 2014 14:07:17 -0700
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-aa8e4f22ab7773352ba3895597189b8097f2c307@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1409175640-32426-2-git-send-email-david.e.box@linux.intel.com>
References: <1409175640-32426-2-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86/iosf:
  Add Kconfig prompt for IOSF_MBI selection
Git-Commit-ID: aa8e4f22ab7773352ba3895597189b8097f2c307
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

Commit-ID:  aa8e4f22ab7773352ba3895597189b8097f2c307
Gitweb:     http://git.kernel.org/tip/aa8e4f22ab7773352ba3895597189b8097f2c307
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Wed, 27 Aug 2014 14:40:39 -0700
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 27 Aug 2014 14:48:33 -0700

x86/iosf: Add Kconfig prompt for IOSF_MBI selection

Fixes an error in having the iosf build as 'default m'. On X86 SoC's the iosf
sideband is the only way to access information for some registers, as opposed to
through MSR's on other Intel architectures. While selecting IOSF_MBI is
preferred, it does mean carrying extra code on non-SoC architectures. This
exports the selection to the user, allowing those driver writers to compile out
iosf code if it's not being built.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1409175640-32426-2-git-send-email-david.e.box@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5d0bf1a..a99988f 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2433,9 +2433,19 @@ config X86_DMA_REMAP
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
 
 config PMC_ATOM
 	def_bool y
