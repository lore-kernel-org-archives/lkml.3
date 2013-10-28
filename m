Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757164Ab3J1OvA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 10:51:00 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51341 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932345Ab3J1OuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 10:50:04 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Nikhil P Rao <nikhil.rao@intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 64/64] PCI: fix truncation of resource size to 32 bits
Date: Mon, 28 Oct 2013 14:48:23 +0000
Message-Id: <1382971703-17393-65-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
References: <1382971703-17393-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.24 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P Rao <nikhil.rao@intel.com>

commit d6776e6d5c2f8db0252f447b09736075e1bbe387 upstream.

_pci_assign_resource() took an int "size" argument, which meant that
sizes larger than 4GB were truncated.  Change type to resource_size_t.

[bhelgaas: changelog]
Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/pci/setup-res.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/setup-res.c b/drivers/pci/setup-res.c
index eea85da..be76eba 100644
--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -206,7 +206,8 @@ static int pci_revert_fw_address(struct resource *res, struct pci_dev *dev,
 	return ret;
 }
 
-static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
+static int _pci_assign_resource(struct pci_dev *dev, int resno,
+				resource_size_t size, resource_size_t min_align)
 {
 	struct resource *res = dev->resource + resno;
 	struct pci_bus *bus;
-- 
1.8.3.2

