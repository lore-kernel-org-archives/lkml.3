Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab3KNXLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 18:11:31 -0500
Received: from mail-yh0-f48.google.com ([209.85.213.48]:35311 "EHLO
	mail-yh0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab3KNXLX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 18:11:23 -0500
Date: Thu, 14 Nov 2013 15:05:32 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
cc: Tony Luck <tony.luck@intel.com>, Chen Gong <gong.chen@linux.intel.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch x86/mce] ACPI, x86: Export boot_cpu_physical_apicid to
 modules
Message-ID: <alpine.DEB.2.02.1311141504080.30112@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"ACPI, x86: Fix extended error log driver to depend on CONFIG_X86_LOCAL_APIC" 
fixed a build error when CONFIG_X86_LOCAL_APIC was not selected and !CONFIG_SMP.
However, since CONFIG_ACPI_EXTLOG is tristate, there is a second build error:

ERROR: "boot_cpu_physical_apicid" [drivers/acpi/acpi_extlog.ko] undefined!

The symbol needs to be exported for it to be available.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 arch/x86/kernel/apic/apic.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -62,6 +62,7 @@ unsigned disabled_cpus;
 
 /* Processor that is doing the boot up */
 unsigned int boot_cpu_physical_apicid = -1U;
+EXPORT_SYMBOL(boot_cpu_physical_apicid);
 
 /*
  * The highest APIC ID seen during enumeration.
