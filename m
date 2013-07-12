Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932113Ab3GKNbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 09:31:31 -0400
Received: from mga03.intel.com ([143.182.124.21]:44761 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755318Ab3GKNb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 09:31:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,1043,1363158000"; 
   d="scan'208";a="363706201"
From: Youquan Song <youquan.song@intel.com>
To: tj@kernel.org, jgarzik@redhat.com, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Cc: seth.heasley@intel.com, james.d.ralston@intel.com,
        ed.ciechanowski@intel.com, Youquan Song <youquan.song@linux.intel.com>,
        Youquan Song <youquan.song@intel.com>, stable@vger.kernel.org
Subject: [PATCH] ata: Fix DVD not dectected at some platform with Wellsburg PCH
Date: Thu, 11 Jul 2013 21:15:57 -0400
Message-Id: <1373591757-416-1-git-send-email-youquan.song@intel.com>
X-Mailer: git-send-email 1.6.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a patch b55f84e2d527182e7c611d466cd0bb6ddce201de "ata_piix: Fix DVD
 not dectected at some Haswell platforms" to fix an issue of DVD not 
recognized on Haswell Desktop platform with Lynx Point. 
Recently, it is also found the same issue at some platformas with Wellsburg PCH.

So deliver a similar patch to fix it by disables 32bit PIO in IDE mode.

Signed-off-by: Youquan Song <youquan.song@intel.com>
Cc: stable@vger.kernel.org
---
 drivers/ata/ata_piix.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/ata_piix.c b/drivers/ata/ata_piix.c
index 9a8a674..424bcbe 100644
--- a/drivers/ata/ata_piix.c
+++ b/drivers/ata/ata_piix.c
@@ -330,7 +330,7 @@ static const struct pci_device_id piix_pci_tbl[] = {
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d00, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
-	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata },
+	{ 0x8086, 0x8d08, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_2port_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
 	{ 0x8086, 0x8d60, PCI_ANY_ID, PCI_ANY_ID, 0, 0, ich8_sata_snb },
 	/* SATA Controller IDE (Wellsburg) */
-- 
1.6.4.2

