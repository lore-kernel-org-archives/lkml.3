Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758337Ab3KYO3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:29:06 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58874 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754177Ab3KYNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:53:36 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Bjorn Helgaas" <bhelgaas@google.com>,
        "Nikhil P Rao" <nikhil.rao@intel.com>
Date: Mon, 25 Nov 2013 13:44:29 +0000
Message-ID: <lsq.1385387069.912023219@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 21/87] PCI: fix truncation of resource size to 32 bits
In-Reply-To: <lsq.1385387069.559528559@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.212
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.53-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P Rao <nikhil.rao@intel.com>

commit d6776e6d5c2f8db0252f447b09736075e1bbe387 upstream.

_pci_assign_resource() took an int "size" argument, which meant that
sizes larger than 4GB were truncated.  Change type to resource_size_t.

[bhelgaas: changelog]
Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pci/setup-res.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -188,7 +188,8 @@ static int pci_revert_fw_address(struct
 	return ret;
 }
 
-static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
+static int _pci_assign_resource(struct pci_dev *dev, int resno,
+				resource_size_t size, resource_size_t min_align)
 {
 	struct resource *res = dev->resource + resno;
 	struct pci_bus *bus;

