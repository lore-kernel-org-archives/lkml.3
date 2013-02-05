Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757106Ab3BEWIG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 17:08:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47831 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757032Ab3BEWHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 17:07:51 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Colin Ian King <colin.king@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 05/93] PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported
Date: Tue,  5 Feb 2013 20:05:54 -0200
Message-Id: <1360102042-10732-6-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
References: <1360102042-10732-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.5 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.king@canonical.com>

commit 9e16721498b0c3d3ebfa0b503c63d35c0a4c0642 upstream.

Right now using pcie_aspm=force will not enable ASPM if the FADT indicates
ASPM is unsupported.  However, the semantics of force should probably allow
for this, especially as they did before 3c076351c4 ("PCI: Rework ASPM
disable code")

This patch just skips the clearing of any ASPM setup that the firmware has
carried out on this bus if pcie_aspm=force is being used.

Reference: http://bugs.launchpad.net/bugs/962038
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pci/pcie/aspm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index b500840..474f22f 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -798,6 +798,9 @@ void pcie_clear_aspm(struct pci_bus *bus)
 {
 	struct pci_dev *child;
 
+	if (aspm_force)
+		return;
+
 	/*
 	 * Clear any ASPM setup that the firmware has carried out on this bus
 	 */
-- 
1.7.9.5

