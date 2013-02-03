Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754447Ab3BCPOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 10:14:25 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34320 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754303Ab3BCO4W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 09:56:22 -0500
Message-Id: <20130203144648.665278219@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 03 Feb 2013 15:47:36 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Colin Ian King <colin.king@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 052/128] PCI: Allow pcie_aspm=force even when FADT indicates it is
 unsupported
In-Reply-To: <20130203144644.035172954@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.216.67.5
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/pcie/aspm.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index b52630b..8474b6a 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -771,6 +771,9 @@ void pcie_clear_aspm(struct pci_bus *bus)
 {
 	struct pci_dev *child;
 
+	if (aspm_force)
+		return;
+
 	/*
 	 * Clear any ASPM setup that the firmware has carried out on this bus
 	 */


