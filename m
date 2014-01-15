Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755520AbaAOWnh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:43:37 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57044 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753614AbaAOWnV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 17:43:21 -0500
Date: Wed, 15 Jan 2014 14:43:10 -0800
From: tip-bot for David Cohen <tipbot@zytor.com>
Message-ID: <tip-4cb9b00f42e07830310319a07e6c91413ee8153e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        david.a.cohen@linux.intel.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
References: <1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/intel-mid] x86, intel-mid:
  Remove deprecated X86_MDFLD and X86_WANT_INTEL_MID configs
Git-Commit-ID: 4cb9b00f42e07830310319a07e6c91413ee8153e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 15 Jan 2014 14:43:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cb9b00f42e07830310319a07e6c91413ee8153e
Gitweb:     http://git.kernel.org/tip/4cb9b00f42e07830310319a07e6c91413ee8153e
Author:     David Cohen <david.a.cohen@linux.intel.com>
AuthorDate: Mon, 16 Dec 2013 17:37:26 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Wed, 15 Jan 2014 14:38:58 -0800

x86, intel-mid: Remove deprecated X86_MDFLD and X86_WANT_INTEL_MID configs

We want to support all Intel MID (Mobile Internet Device) platforms
with a single config selection. This patch removes deprecated
CONFIG_X86_MDFLD and X86_WANT_INTEL_MID options in favor of having
CONFIG_X86_INTEL_MID only.

Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
Link: http://lkml.kernel.org/r/1387244246-20714-1-git-send-email-david.a.cohen@linux.intel.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/Kconfig | 30 +++++++-----------------------
 1 file changed, 7 insertions(+), 23 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0952ecd..edcf80e 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -438,42 +438,26 @@ config X86_INTEL_CE
 	  This option compiles in support for the CE4100 SOC for settop
 	  boxes and media devices.
 
-config X86_WANT_INTEL_MID
+config X86_INTEL_MID
 	bool "Intel MID platform support"
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
-	---help---
-	  Select to build a kernel capable of supporting Intel MID platform
-	  systems which do not have the PCI legacy interfaces (Moorestown,
-	  Medfield). If you are building for a PC class system say N here.
-
-if X86_WANT_INTEL_MID
-
-config X86_INTEL_MID
-	bool
-
-config X86_MDFLD
-       bool "Medfield MID platform"
 	depends on PCI
 	depends on PCI_GOANY
 	depends on X86_IO_APIC
-	select X86_INTEL_MID
 	select SFI
+	select I2C
 	select DW_APB_TIMER
 	select APB_TIMER
-	select I2C
-	select SPI
 	select INTEL_SCU_IPC
-	select X86_PLATFORM_DEVICES
 	select MFD_INTEL_MSIC
 	---help---
-	  Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
-	  Internet Device(MID) platform. 
-	  Unlike standard x86 PCs, Medfield does not have many legacy devices
-	  nor standard legacy replacement devices/features. e.g. Medfield does
-	  not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
+	  Select to build a kernel capable of supporting Intel MID (Mobile
+	  Internet Device) platform systems which do not have the PCI legacy
+	  interfaces. If you are building for a PC class system say N here.
 
-endif
+	  Intel MID platforms are based on an Intel processor and chipset which
+	  consume less power than most of the x86 derivatives.
 
 config X86_INTEL_LPSS
 	bool "Intel Low Power Subsystem Support"
