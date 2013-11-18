Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3KRSvz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Nov 2013 13:51:55 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57562 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3KRSlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Nov 2013 13:41:35 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Nikhil P Rao <nikhil.rao@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.4 04/12] PCI: fix truncation of resource size to 32 bits
Date: Mon, 18 Nov 2013 10:41:37 -0800
Message-Id: <20131118184131.435164886@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc0.dirty
In-Reply-To: <20131118184130.257996039@linuxfoundation.org>
References: <20131118184130.257996039@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P Rao <nikhil.rao@intel.com>

commit d6776e6d5c2f8db0252f447b09736075e1bbe387 upstream.

_pci_assign_resource() took an int "size" argument, which meant that
sizes larger than 4GB were truncated.  Change type to resource_size_t.

[bhelgaas: changelog]
Signed-off-by: Nikhil P Rao <nikhil.rao@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/setup-res.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/pci/setup-res.c
+++ b/drivers/pci/setup-res.c
@@ -206,7 +206,8 @@ static int pci_revert_fw_address(struct
 	return ret;
 }
 
-static int _pci_assign_resource(struct pci_dev *dev, int resno, int size, resource_size_t min_align)
+static int _pci_assign_resource(struct pci_dev *dev, int resno,
+				resource_size_t size, resource_size_t min_align)
 {
 	struct resource *res = dev->resource + resno;
 	struct pci_bus *bus;


