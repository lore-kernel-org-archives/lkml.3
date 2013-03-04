Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab3CDDoo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:44:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33118 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757157Ab3CDDoj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:44:39 -0500
Message-Id: <20130304033711.721282641@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:37:49 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Greg Pearson <greg.pearson@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [ 042/153] x86/apic: Use x2apic physical mode based on FADT setting
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Pearson <greg.pearson@hp.com>

commit ea0dcf903e7d76aa5d483d876215fedcfdfe140f upstream.

Provide systems that do not support x2apic cluster mode
a mechanism to select x2apic physical mode using the
FADT FORCE_APIC_PHYSICAL_DESTINATION_MODE bit.

Changes from v1: (based on Suresh's comments)
 - removed #ifdef CONFIG_ACPI
 - removed #include <linux/acpi.h>

Signed-off-by: Greg Pearson <greg.pearson@hp.com>
Acked-by: Suresh Siddha <suresh.b.siddha@intel.com>
Link: http://lkml.kernel.org/r/1335313436-32020-1-git-send-email-greg.pearson@hp.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/apic/x2apic_phys.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/arch/x86/kernel/apic/x2apic_phys.c
+++ b/arch/x86/kernel/apic/x2apic_phys.c
@@ -24,6 +24,12 @@ static int x2apic_acpi_madt_oem_check(ch
 {
 	if (x2apic_phys)
 		return x2apic_enabled();
+	else if ((acpi_gbl_FADT.header.revision >= FADT2_REVISION_ID) &&
+		(acpi_gbl_FADT.flags & ACPI_FADT_APIC_PHYSICAL) &&
+		x2apic_enabled()) {
+		printk(KERN_DEBUG "System requires x2apic physical mode\n");
+		return 1;
+	}
 	else
 		return 0;
 }


