Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaL2BM7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 20:12:59 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33195 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751911AbaL2BMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 20:12:17 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Tejun Heo" <tj@kernel.org>,
        "Dominik Mierzejewski" <dominik@greysector.net>
Date: Mon, 29 Dec 2014 02:11:31 +0100
Message-ID: <lsq.1419815491.459542017@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 05/27] ahci: disable MSI on SAMSUNG 0xa800 SSD
In-Reply-To: <lsq.1419815490.288081487@decadent.org.uk>
X-SA-Exim-Connect-IP: 46.189.28.191
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.66-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 2b21ef0aae65f22f5ba86b13c4588f6f0c2dbefb upstream.

Just like 0x1600 which got blacklisted by 66a7cbc303f4 ("ahci: disable
MSI instead of NCQ on Samsung pci-e SSDs on macbooks"), 0xa800 chokes
on NCQ commands if MSI is enabled.  Disable MSI.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Dominik Mierzejewski <dominik@greysector.net>
Link: https://bugzilla.kernel.org/show_bug.cgi?id=89171
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -502,6 +502,7 @@ static const struct pci_device_id ahci_p
 	 * enabled.  https://bugzilla.kernel.org/show_bug.cgi?id=60731
 	 */
 	{ PCI_VDEVICE(SAMSUNG, 0x1600), board_ahci_nomsi },
+	{ PCI_VDEVICE(SAMSUNG, 0xa800), board_ahci_nomsi },
 
 	/* Enmotus */
 	{ PCI_DEVICE(0x1c44, 0x8000), board_ahci },

