Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510AbaK2Amc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 19:42:32 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:65276 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751324AbaK2Ama (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 19:42:30 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linux PM list <linux-pm@vger.kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tony Luck <tony.luck@intel.com>, linux-sh@vger.kernel.org,
        Fenghua Yu <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        Kevin Hilman <khilman@kernel.org>
Subject: [PATCH] PM / Kconfig: Do not select PM directly from Kconfig files
Date: Sat, 29 Nov 2014 02:03:48 +0100
Message-ID: <4088467.A4Xd3YfMSv@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

It is not valid to select CONFIG_PM directly without selecting
CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME too, because that breaks
dependencies (ia64 does that) and it is not necessary to select
CONFIG_PM directly if CONFIG_PM_SLEEP or CONFIG_PM_RUNTIME is
set, because it will be set automatically then (sh does that).

Fix those mistakes.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 arch/ia64/Kconfig |    1 -
 arch/sh/Kconfig   |    1 -
 2 files changed, 2 deletions(-)

Index: linux-pm/arch/ia64/Kconfig
===================================================================
--- linux-pm.orig/arch/ia64/Kconfig
+++ linux-pm/arch/ia64/Kconfig
@@ -11,7 +11,6 @@ config IA64
 	select PCI if (!IA64_HP_SIM)
 	select ACPI if (!IA64_HP_SIM)
 	select ARCH_MIGHT_HAVE_ACPI_PDC if ACPI
-	select PM if (!IA64_HP_SIM)
 	select HAVE_UNSTABLE_SCHED_CLOCK
 	select HAVE_IDE
 	select HAVE_OPROFILE
Index: linux-pm/arch/sh/Kconfig
===================================================================
--- linux-pm.orig/arch/sh/Kconfig
+++ linux-pm/arch/sh/Kconfig
@@ -222,7 +222,6 @@ config CPU_SHX3
 config ARCH_SHMOBILE
 	bool
 	select ARCH_SUSPEND_POSSIBLE
-	select PM
 	select PM_RUNTIME
 
 config CPU_HAS_PMU

