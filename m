Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab3BCO6a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 09:58:30 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34598 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754202Ab3BCO6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:58:21 -0500
Message-Id: <20130203144653.917896025@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:48:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alan Cox <alan@linux.intel.com>,
        Jeff Garzik <jgarzik@redhat.com>
Subject: [ 112/128] ahci: Add identifiers for ASM106x devices
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Cox <alan@linux.intel.com>

commit 7b4f6ecacb14f384adc1a5a67ad95eb082c02bd1 upstream.

They don't always appear as AHCI class devices but instead as IDE class.

Based on an initial patch by Hiroaki Nito

Resolves-bug: https://bugzilla.kernel.org/show_bug.cgi?id=42804
Signed-off-by: Alan Cox <alan@linux.intel.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 51548dd..7862d17 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -405,7 +405,10 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	{ PCI_VDEVICE(PROMISE, 0x3f20), board_ahci },	/* PDC42819 */
 
 	/* Asmedia */
-	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0601), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0602), board_ahci },	/* ASM1060 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0611), board_ahci },	/* ASM1061 */
+	{ PCI_VDEVICE(ASMEDIA, 0x0612), board_ahci },	/* ASM1062 */
 
 	/* Generic, PCI class code for AHCI */
 	{ PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,


