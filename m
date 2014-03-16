Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116AbaCPREL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2014 13:04:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:19428 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755275AbaCPRED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2014 13:04:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,665,1389772800"; 
   d="scan'208";a="501094165"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [PATCH V3 04/11] ACPI: remove unsupported serial PNP ids from acpi pnp scan handler id lsit
Date: Mon, 17 Mar 2014 01:03:10 +0800
Message-Id: <1394989397-2733-5-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394989397-2733-1-git-send-email-rui.zhang@intel.com>
References: <1394989397-2733-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "serial" pnp driver supports some unknown PNP modems (PNPCXXX/PNPDXXX)
by matching magic strings in the pnp device name or the pnp device card name.

ACPI enumerated PNP device neither supports pnp card, nor supports those magic
strings in its device name, which means this mechamism never works for ACPI
enumerated PNPCXXX/PNPDXXX devices.
So it is safe to remove those two ids from the ACPI pnp scan handler id list.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/acpi/acpi_pnp.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index db49e9e..2a7f86f 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -300,8 +300,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[]= {
 	{"LTS0001"}, /* LG C1 EXPRESS DUAL (C1-PB11A3) touch screen (actually a FUJ02E6 in disguise) */
 	{"WCI0003"}, /* Rockwell's (PORALiNK) 33600 INT PNP */
 	{"WEC1022"}, /* Winbond CIR port, should not be probed. We should keep track of it to prevent the legacy serial driver from probing it */
-	{"PNPCXXX"}, /* Unknown PnP modems */
-	{"PNPDXXX"}, /* More unknown PnP modems */
 	/* scl200wdt */
 	{"NSC0800"}, /* National Semiconductor PC87307/PC97307 watchdog component */
 	/* mpu401 */
-- 
1.7.9.5

