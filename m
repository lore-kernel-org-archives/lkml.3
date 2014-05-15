Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbaEOGr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 02:47:58 -0400
Received: from mga11.intel.com ([192.55.52.93]:52462 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047AbaEOGoa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 02:44:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1057,1389772800"; 
   d="scan'208";a="532238240"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V6 03/11] ACPI: remove ids that does not comply with the ACPI PNP id rule
Date: Thu, 15 May 2014 14:44:08 +0800
Message-Id: <1400136256-2218-4-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
References: <1400136256-2218-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The acpi pnp scan handler id list just copies all the ids from all the
struct pnp_device_id instances, but some of them do not
comply with the ACPI PNP id rule (3 Alpha Charactors + 4 Hex numbers).

For those ids, the coressponding devices will never be enumerated
via ACPI, so it is safe to remove those ids from the PNPACPI white list.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_pnp.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 57d14ed..d206616 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -33,10 +33,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[] = {
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
-- 
1.8.3.2

