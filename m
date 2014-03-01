Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753293AbaCAUeu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 15:34:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35341 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201AbaCAUes (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 15:34:48 -0500
Date: Sat, 1 Mar 2014 12:34:36 -0800
From: "tip-bot for David E. Box" <tipbot@zytor.com>
Message-ID: <tip-0fd9bdfa3b7698e30d2fbc4a029ded0f3428cf10@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.e.box@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1393296442-12942-3-git-send-email-david.e.box@linux.intel.com>
References: <1393296442-12942-3-git-send-email-david.e.box@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/platform] x86, iosf:
  Change IOSF_MBI Kconfig to default y
Git-Commit-ID: 0fd9bdfa3b7698e30d2fbc4a029ded0f3428cf10
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

Commit-ID:  0fd9bdfa3b7698e30d2fbc4a029ded0f3428cf10
Gitweb:     http://git.kernel.org/tip/0fd9bdfa3b7698e30d2fbc4a029ded0f3428cf10
Author:     David E. Box <david.e.box@linux.intel.com>
AuthorDate: Mon, 24 Feb 2014 18:47:22 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 28 Feb 2014 19:56:13 -0800

x86, iosf: Change IOSF_MBI Kconfig to default y

The IOSF Mailbox interface is an access mechanism used by multiple drivers to
communicate with key configuration registers on new Intel SOC platforms. The
interface is ubiquitous enough that we need to ensure the availability of the
driver in non-EXPERT x86 kernels.

[ hpa: I think it makes sense to build these in unless EXPERT is set,
  in which case it should be optional.  Ideally the IOSF driver should
  be possible to build as a module on which other modules can depend,
  but that can be done on top of this work. ]

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Link: http://lkml.kernel.org/r/1393296442-12942-3-git-send-email-david.e.box@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..1487fdd 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -2413,11 +2413,12 @@ config X86_DMA_REMAP
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
