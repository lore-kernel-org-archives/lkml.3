Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754957Ab3KKRwM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 12:52:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46588 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754920Ab3KKRwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 12:52:06 -0500
Date: Mon, 11 Nov 2013 09:51:47 -0800
From: "tip-bot for Luck, Tony" <tipbot@zytor.com>
Message-ID: <tip-9ebddac7ea2a1f4b4ce3335a78312a58dfaadb4d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tony.luck@intel.com, gong.chen@linux.intel.com, tglx@linutronix.de,
        rjw@rjwysocki.net, fengguang.wu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, gong.chen@linux.intel.com, tglx@linutronix.de,
        rjw@rjwysocki.net, fengguang.wu@intel.com
In-Reply-To: <6be3afdcad7968f7fb7c0b681e547b3e872e44dd.1383947368.git.tony.luck@intel.com>
References: <6be3afdcad7968f7fb7c0b681e547b3e872e44dd.1383947368.git.tony.luck@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mce] ACPI, x86:
  Fix extended error log driver to depend on CONFIG_X86_LOCAL_APIC
Git-Commit-ID: 9ebddac7ea2a1f4b4ce3335a78312a58dfaadb4d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 11 Nov 2013 09:51:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ebddac7ea2a1f4b4ce3335a78312a58dfaadb4d
Gitweb:     http://git.kernel.org/tip/9ebddac7ea2a1f4b4ce3335a78312a58dfaadb4d
Author:     Luck, Tony <tony.luck@intel.com>
AuthorDate: Fri, 8 Nov 2013 14:03:33 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Mon, 11 Nov 2013 10:21:29 +0100

ACPI, x86: Fix extended error log driver to depend on CONFIG_X86_LOCAL_APIC

Randconfig build by Fengguang's robot army reported:

   drivers/built-in.o: In function `extlog_print':
   >> acpi_extlog.c:(.text+0xcc719): undefined reference to `boot_cpu_physical_apicid'

The config had CONFIG_SMP=n so we picked up this definition from:

  <asm/cpu.h>: #define cpu_physical_id(cpu) boot_cpu_physical_apicid

But boot_cpu_physical_apicid is defined in arch/x86/kernel/apic/apic.c
which is only built if CONFIG_X86_LOCAL_APIC=y.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Link: http://lkml.kernel.org/r/6be3afdcad7968f7fb7c0b681e547b3e872e44dd.1383947368.git.tony.luck@intel.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 drivers/acpi/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/acpi/Kconfig b/drivers/acpi/Kconfig
index 08eadb4..e11faae 100644
--- a/drivers/acpi/Kconfig
+++ b/drivers/acpi/Kconfig
@@ -374,7 +374,7 @@ source "drivers/acpi/apei/Kconfig"
 
 config ACPI_EXTLOG
 	tristate "Extended Error Log support"
-	depends on X86_MCE
+	depends on X86_MCE && X86_LOCAL_APIC
 	select EFI
 	select UEFI_CPER
 	default n
