Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756277Ab3AXVRe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:17:34 -0500
Received: from mail.kernel.org ([198.145.19.201]:40705 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757020Ab3AXVQS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:16:18 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Colin Ian King <colin.king@canonical.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [ 09/22] PCI: Allow pcie_aspm=force even when FADT indicates it is unsupported
Date: Thu, 24 Jan 2013 13:15:30 -0800
Message-Id: <20130124211507.874894460@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130124211504.701368763@linuxfoundation.org>
References: <20130124211504.701368763@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/pcie/aspm.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -798,6 +798,9 @@ void pcie_clear_aspm(struct pci_bus *bus
 {
 	struct pci_dev *child;
 
+	if (aspm_force)
+		return;
+
 	/*
 	 * Clear any ASPM setup that the firmware has carried out on this bus
 	 */


