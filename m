Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755192AbaAOW2V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 17:28:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40975 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753479AbaAOV51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:57:27 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Simon Guinot <sguinot@lacie.com>, Tejun Heo <tj@kernel.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 131/166] ahci: add PCI ID for Marvell 88SE9170 SATA controller
Date: Wed, 15 Jan 2014 13:52:25 -0800
Message-Id: <1389822780-4729-132-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Guinot <sguinot@lacie.com>

commit e098f5cbe9d410e7878b50f524dce36cc83ec40e upstream.

This patch adds support for the PCI ID provided by the Marvell 88SE9170
SATA controller.

Signed-off-by: Simon Guinot <sguinot@lacie.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
[ kamal: backport to 3.8 (revert to hardcoded PCI id)
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/ata/ahci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 6468d43..67fb282 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -425,6 +425,9 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9128 */
 	{ PCI_DEVICE(0x1b4b, 0x9125),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9125 */
+	{ PCI_DEVICE_SUB(0x1b4b, 0x9178,
+			 0x1b4b, 0x9170),
+	  .driver_data = board_ahci_yes_fbs },			/* 88se9170 */
 	{ PCI_DEVICE(0x1b4b, 0x917a),
 	  .driver_data = board_ahci_yes_fbs },			/* 88se9172 */
 	{ PCI_DEVICE(0x1b4b, 0x9192),
-- 
1.8.3.2

