Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933262Ab3E3OqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 10:46:20 -0400
Received: from g6t0185.atlanta.hp.com ([15.193.32.62]:27968 "EHLO
	g6t0185.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933053Ab3E3OqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 10:46:12 -0400
From: Betty Dall <betty.dall@hp.com>
To: rjw@sisk.pl, bhelgaas@google.com
Cc: ying.huang@intel.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Betty Dall <betty.dall@hp.com>
Subject: [PATCH v2 1/3] PCI/AER: Fix incorrect return from aer_hest_parse()
Date: Thu, 30 May 2013 08:39:27 -0600
Message-Id: <1369924769-17183-2-git-send-email-betty.dall@hp.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
References: <1369924769-17183-1-git-send-email-betty.dall@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function aer_hest_parse() is called to determine if the given
PCI device is firmware first or not. The code loops through each
section of the HEST table to look for a match. The bug is that
the function always returns whether the last HEST section is firmware
first. The fix stops the iteration once the info.firmware_first
variable is set.  This is similar to how the function aer_hest_parse_aff()
stops the iteration.

Signed-off-by: Betty Dall <betty.dall@hp.com>
---

 drivers/pci/pcie/aer/aerdrv_acpi.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)


diff --git a/drivers/pci/pcie/aer/aerdrv_acpi.c b/drivers/pci/pcie/aer/aerdrv_acpi.c
index 5194a7d..39b8671 100644
--- a/drivers/pci/pcie/aer/aerdrv_acpi.c
+++ b/drivers/pci/pcie/aer/aerdrv_acpi.c
@@ -42,6 +42,9 @@ static int aer_hest_parse(struct acpi_hest_header *hest_hdr, void *data)
 	u8 bridge = 0;
 	int ff = 0;
 
+	if (info->firmware_first)
+		return 0;
+
 	switch (hest_hdr->type) {
 	case ACPI_HEST_TYPE_AER_ROOT_PORT:
 		pcie_type = PCI_EXP_TYPE_ROOT_PORT;
