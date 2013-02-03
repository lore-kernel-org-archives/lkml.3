Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3BCPK4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:10:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34388 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754504Ab3BCO4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:46 -0500
Message-Id: <20130203144650.239683596@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:54 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Thomas Schlichter <thomas.schlichter@web.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [ 070/128] ACPI / processor: Get power info before updating the C-states
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Schlichter <thomas.schlichter@web.de>

commit f427e5f1cf75bba84cccdac1d8a90552d9ae1065 upstream.

acpi_processor_get_power_info() has to be called before
acpi_processor_setup_cpuidle_states() to have the latest
information available. This fixes the missing C-state information
after AC-->DC transition.

Signed-off-by: Thomas Schlichter <thomas.schlichter@web.de>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/acpi/processor_idle.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/acpi/processor_idle.c b/drivers/acpi/processor_idle.c
index fea6f8d..ed9a1cc 100644
--- a/drivers/acpi/processor_idle.c
+++ b/drivers/acpi/processor_idle.c
@@ -1152,6 +1152,7 @@ int acpi_processor_cst_has_changed(struct acpi_processor *pr)
 		}
 
 		/* Populate Updated C-state information */
+		acpi_processor_get_power_info(pr);
 		acpi_processor_setup_cpuidle_states(pr);
 
 		/* Enable all cpuidle devices */


