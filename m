Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754867AbaE3CQD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:16:03 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:50651 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754552AbaE3COe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:14:34 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Zhang Rui <rui.zhang@intel.com>
Cc: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        matthew.garrett@nebula.com, mika.westerberg@linux.intel.com
Subject: [PATCH 3/10] ACPI / scan: drop IDs that do not comply with the ACPI PNP ID rule
Date: Fri, 30 May 2014 04:24:04 +0200
Message-ID: <1545244.LmV7JB6kqf@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.15.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <35042328.kk6ZUUdfyN@vostro.rjw.lan>
References: <1400781753-2682-1-git-send-email-rui.zhang@intel.com> <35042328.kk6ZUUdfyN@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

The PNP ACPI scan handler device ID list includes all the IDs from
all of the struct pnp_device_id instances in the tree, but some of
them do not follow the ACPI PNP ID rule (3 letters + 4 hex digits).

For those IDs, the coressponding devices will never be enumerated
via ACPI, so it is safe to remove them from the PNP ACPI ID list.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
[rjw: Subject and changelog]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
---
drivers/acpi/acpi_pnp.c | 4 ----
 drivers/acpi/acpi_pnp.c |    4 ----
 1 file changed, 4 deletions(-)

Index: linux-pm/drivers/acpi/acpi_pnp.c
===================================================================
--- linux-pm.orig/drivers/acpi/acpi_pnp.c
+++ linux-pm/drivers/acpi/acpi_pnp.c
@@ -34,10 +34,6 @@ static const struct acpi_device_id acpi_
 	/* ide   */
 	{"PNP0600"},		/* Generic ESDI/IDE/ATA compatible hard disk controller */
 	/* ns558 */
-	{"@P@0001"},		/* ALS 100 */
-	{"@P@0020"},		/* ALS 200 */
-	{"@P@1001"},		/* ALS 100+ */
-	{"@P@2001"},		/* ALS 120 */
 	{"ASB16fd"},		/* AdLib NSC16 */
 	{"AZT3001"},		/* AZT1008 */
 	{"CDC0001"},		/* Opl3-SAx */

