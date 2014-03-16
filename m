Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbaCPREJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 13:04:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:53756 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbaCPRED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 13:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,665,1389772800"; 
   d="scan'208";a="501093840"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V3 03/11] ACPI: remove ids that does not comply with the ACPI PNP id rule
Date: Mon, 17 Mar 2014 01:03:09 +0800
Message-Id: <1394989397-2733-4-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394989397-2733-1-git-send-email-rui.zhang@intel.com>
References: <1394989397-2733-1-git-send-email-rui.zhang@intel.com>
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
 drivers/acpi/acpi_pnp.c |    4 ----
 1 file changed, 4 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index edeed1d..db49e9e 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -33,10 +33,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[]= {
 	/* ide	 */
 	{"PNP0600"}, /* Generic ESDI/IDE/ATA compatible hard disk controller */
 	/* ns558 */
-	{"@P@0001"}, /* ALS 100 */
-	{"@P@0020"}, /* ALS 200 */
-	{"@P@1001"}, /* ALS 100+ */
-	{"@P@2001"}, /* ALS 120 */
 	{"ASB16fd"}, /* AdLib NSC16 */
 	{"AZT3001"}, /* AZT1008 */
 	{"CDC0001"}, /* Opl3-SAx */
-- 
1.7.9.5

