Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab3AVCHR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 21:07:17 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:48951 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752267Ab3AVCHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 21:07:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Lv Zheng <lv.zheng@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 4/4] ACPI / PM: Sanitize checks in acpi_power_on_resources()
Date: Tue, 22 Jan 2013 03:11:32 +0100
Message-ID: <2460397.W1PpBYs6jy@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1792467.qHBR6KraFh@vostro.rjw.lan>
References: <1792467.qHBR6KraFh@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

After the only user of acpi_power_on_resources(),
acpi_bus_init_power(), has been changed to avoid calling it
for state equal to ACPI_STATE_D3_COLD, it doesn't have to special
case that state any more.

For this reason, modify the checks in acpi_power_on_resources()
so that it returns -EINVAL for ACPI_STATE_D3_COLD as it should.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/power.c |    5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/power.c
===================================================================
--- linux-pm.orig/drivers/acpi/power.c
+++ linux-pm/drivers/acpi/power.c
@@ -622,12 +622,9 @@ int acpi_power_get_inferred_state(struct
 
 int acpi_power_on_resources(struct acpi_device *device, int state)
 {
-	if (!device || state < ACPI_STATE_D0 || state > ACPI_STATE_D3_COLD)
+	if (!device || state < ACPI_STATE_D0 || state > ACPI_STATE_D3_HOT)
 		return -EINVAL;
 
-	if (state == ACPI_STATE_D3_COLD)
-		return 0;
-
 	return acpi_power_on_list(&device->power.states[state].resources);
 }
 

