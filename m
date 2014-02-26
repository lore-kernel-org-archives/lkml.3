Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaBZJLm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 04:11:42 -0500
Received: from mga01.intel.com ([192.55.52.88]:35127 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaBZJL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 04:11:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,546,1389772800"; 
   d="scan'208";a="488297863"
From: Zhang Rui <rui.zhang@intel.com>
To: linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: bhelgaas@google.com, matthew.garrett@nebula.com,
        rafael.j.wysocki@intel.com, dmitry.torokhov@gmail.com,
        Zhang Rui <rui.zhang@intel.com>
Subject: [RFC PATCH 4/8] PNPACPI: remove unsupported serial PNP ids from PNPACPI id list
Date: Wed, 26 Feb 2014 17:11:10 +0800
Message-Id: <1393405874-3266-5-git-send-email-rui.zhang@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
References: <1393405874-3266-1-git-send-email-rui.zhang@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "serial" pnp driver supports some unknown PNP modems (PNPCXXX/PNPDXXX)
by matching magic strings in the pnp device name or the pnp device card name.

ACPI enumerated PNP device neither supports pnp card,
nor supports those magic strings in its device name,
which means this mechamism never works for ACPI enumerated
PNPCXXX/PNPDXXX devices.
So it is safe to remove those two ids from the PNPACPI id list.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
---
 drivers/pnp/pnpacpi/core.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/pnp/pnpacpi/core.c b/drivers/pnp/pnpacpi/core.c
index d47fbdf..36dda39 100644
--- a/drivers/pnp/pnpacpi/core.c
+++ b/drivers/pnp/pnpacpi/core.c
@@ -341,8 +341,6 @@ static const struct acpi_device_id acpi_pnp_device_ids[]= {
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

