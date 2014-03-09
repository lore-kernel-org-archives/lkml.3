Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408AbaCIRPf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Mar 2014 13:15:35 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51108 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751981AbaCIRPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Mar 2014 13:15:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Aubrey Li <aubrey.li@intel.com>
Subject: [PATCH] Revert "ACPI / sleep: pm_power_off needs more sanity checks to be installed"
Date: Sun, 09 Mar 2014 18:30:50 +0100
Message-ID: <2617726.ByJ3yc2hCY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <4824481.V0Gqxh5Nec@vostro.rjw.lan>
References: <CADDKRnCTBiGC2fkd1Utp7BY7vjORcHh4O9GgqfMP7iDfFkNKuw@mail.gmail.com> <4129487.hPye7CfaJv@vostro.rjw.lan> <4824481.V0Gqxh5Nec@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

Revert commit 3130497f5bab (ACPI / sleep: pm_power_off needs more
sanity checks to be installed) that breaks power ACPI power off on a
lot of systems, because it checks wrong registers.

Fixes: 3130497f5bab (ACPI / sleep: pm_power_off needs more sanity checks to be installed)
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---

Hi Linus,

Can you take this for 3.14-rc6 directly so that the breakage is not present
in that -rc, please?

I obviously trusted the author of commit 3130497f5bab too much which I shouldn't
have done.  My bad and sorry about this mess.

Rafael

---
 drivers/acpi/sleep.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux-pm/drivers/acpi/sleep.c
===================================================================
--- linux-pm.orig/drivers/acpi/sleep.c
+++ linux-pm/drivers/acpi/sleep.c
@@ -807,12 +807,7 @@ int __init acpi_sleep_init(void)
 	acpi_sleep_hibernate_setup();
 
 	status = acpi_get_sleep_type_data(ACPI_STATE_S5, &type_a, &type_b);
-	/*
-	 * Check both ACPI S5 object and ACPI sleep registers to
-	 * install pm_power_off_prepare/pm_power_off hook
-	 */
-	if (ACPI_SUCCESS(status) && acpi_gbl_FADT.sleep_control.address
-	    && acpi_gbl_FADT.sleep_status.address) {
+	if (ACPI_SUCCESS(status)) {
 		sleep_states[ACPI_STATE_S5] = 1;
 		pm_power_off_prepare = acpi_power_off_prepare;
 		pm_power_off = acpi_power_off;

