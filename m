Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752650Ab3FNMYV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 08:24:21 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:37237 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab3FNMYR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 08:24:17 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Aaron Lu <aaron.lu@intel.com>, Lan Tianyu <tianyu.lan@intel.com>
Subject: [PATCH 2/4] ACPI / PM: Replace ACPI_STATE_D3 with ACPI_STATE_D3_COLD in device_pm.c
Date: Fri, 14 Jun 2013 14:31:46 +0200
Message-ID: <5718188.sCHoszPloi@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <6895318.cKDBc4OdI0@vostro.rjw.lan>
References: <6895318.cKDBc4OdI0@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

The two symbols ACPI_STATE_D3 and ACPI_STATE_D3_COLD actually
represent the same number (4), but ACPI_STATE_D3 is slightly
ambigugous, because it may not be clear that it really means D3cold
and not D3hot at first sight.

Remove that ambiguity from drivers/acpi/device_pm.c by making it
use ACPI_STATE_D3_COLD everywhere instead of ACPI_STATE_D3.

Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
 drivers/acpi/device_pm.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-pm/drivers/acpi/device_pm.c
===================================================================
--- linux-pm.orig/drivers/acpi/device_pm.c
+++ linux-pm/drivers/acpi/device_pm.c
@@ -424,7 +424,7 @@ static int acpi_dev_pm_get_state(struct
 	unsigned long long d_min, d_max;
 	bool wakeup = false;
 
-	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3)
+	if (d_max_in < ACPI_STATE_D0 || d_max_in > ACPI_STATE_D3_COLD)
 		return -EINVAL;
 
 	if (d_max_in > ACPI_STATE_D3_HOT) {
@@ -443,7 +443,7 @@ static int acpi_dev_pm_get_state(struct
 	 * the lowest limit with the specified one.
 	 */
 	d_min = ACPI_STATE_D0;
-	d_max = ACPI_STATE_D3;
+	d_max = ACPI_STATE_D3_COLD;
 
 	/*
 	 * If present, _SxD methods return the minimum D-state (highest power
@@ -680,8 +680,8 @@ static int acpi_dev_pm_low_power(struct
 		return 0;
 
 	power_state = acpi_dev_pm_get_state(dev, adev, system_state,
-					    ACPI_STATE_D3, NULL);
-	if (power_state < ACPI_STATE_D0 || power_state > ACPI_STATE_D3)
+					    ACPI_STATE_D3_COLD, NULL);
+	if (power_state < ACPI_STATE_D0 || power_state > ACPI_STATE_D3_COLD)
 		return -EIO;
 
 	return acpi_device_set_power(adev, power_state);

