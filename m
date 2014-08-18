Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844AbaHRJfO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 05:35:14 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:42784 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752762AbaHRJfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 05:35:05 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Romain Degez <romain.degez@gmail.com>, Tejun Heo <tj@kernel.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 070/137] ahci: add support for the Promise FastTrak TX8660 SATA HBA (ahci mode)
Date: Mon, 18 Aug 2014 10:32:11 +0100
Message-Id: <1408354398-10226-71-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
References: <1408354398-10226-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.15 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Degez <romain.degez@gmail.com>

commit b32bfc06aefab61acc872dec3222624e6cd867ed upstream.

Add support of the Promise FastTrak TX8660 SATA HBA in ahci mode by
registering the board in the ahci_pci_tbl[].

Note: this HBA also provide a hardware RAID mode when activated in
BIOS but specific drivers from the manufacturer are required in this
case.

Signed-off-by: Romain Degez <romain.degez@gmail.com>
Tested-by: Romain Degez <romain.degez@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 7ce164157768..7d8ef58b4421 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -455,6 +455,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 
 	/* Promise */
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
+	{ PCI_VDEVICE(PROMISE, 0x3781), board_ahci },   /* FastTrak TX8660 ahci-mode */
 
 	/* Asmedia */
 	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
-- 
1.9.1

