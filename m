Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755369Ab3KOHpv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 02:45:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:50578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab3KOHpm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 02:45:42 -0500
Date: Thu, 14 Nov 2013 23:45:24 -0800
From: tip-bot for David Rientjes <tipbot@zytor.com>
Message-ID: <tip-cc08e04c3fdcaab767b8db27527002b2b4d758cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tony.luck@intel.com, gong.chen@linux.intel.com, tglx@linutronix.de,
        rjw@rjwysocki.net, rientjes@google.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tony.luck@intel.com, gong.chen@linux.intel.com, tglx@linutronix.de,
        rjw@rjwysocki.net, rientjes@google.com
In-Reply-To: <alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86: Export 'boot_cpu_physical_apicid'
  to modules
Git-Commit-ID: cc08e04c3fdcaab767b8db27527002b2b4d758cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Thu, 14 Nov 2013 23:45:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cc08e04c3fdcaab767b8db27527002b2b4d758cb
Gitweb:     http://git.kernel.org/tip/cc08e04c3fdcaab767b8db27527002b2b4d758cb
Author:     David Rientjes <rientjes@google.com>
AuthorDate: Thu, 14 Nov 2013 15:05:32 -0800
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Fri, 15 Nov 2013 08:38:30 +0100

x86: Export 'boot_cpu_physical_apicid' to modules

Commit 9ebddac7ea2a "ACPI, x86: Fix extended error log driver to depend on
CONFIG_X86_LOCAL_APIC" fixed a build error when CONFIG_X86_LOCAL_APIC was not
selected and !CONFIG_SMP.

However, since CONFIG_ACPI_EXTLOG is tristate, there is a second build error:

  ERROR: "boot_cpu_physical_apicid" [drivers/acpi/acpi_extlog.ko] undefined!

The symbol needs to be exported for it to be available.

Signed-off-by: David Rientjes <rientjes@google.com>
Acked-by: Tony Luck <tony.luck@intel.com>
Cc: Chen Gong <gong.chen@linux.intel.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Link: http://lkml.kernel.org/r/alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com
[ Changed it to a _GPL() export. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index a7eb82d..befe498 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,6 +62,7 @@ unsigned disabled_cpus;
 
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
+EXPORT_SYMBOL_GPL(boot_cpu_physical_apicid);
 
 /*
  * The highest APIC ID seen during enumeration.
