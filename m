Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966025Ab3E2MbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:31:20 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:59883 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965855Ab3E2MbT convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:1>);
	Wed, 29 May 2013 08:31:19 -0400
Message-Id: <51A6113302000078000D99A3@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 29 May 2013 13:31:15 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen-pciback: more uses of cached MSI-X capability
 offset
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jan Beulich <jbeulich@suse.com>

---
 drivers/xen/xen-pciback/pci_stub.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- 3.10-rc3/drivers/xen/xen-pciback/pci_stub.c
+++ 3.10-rc3-xen-pciback-MSI-X-cap/drivers/xen/xen-pciback/pci_stub.c
@@ -106,7 +106,7 @@ static void pcistub_device_release(struc
 	else
 		pci_restore_state(dev);
 
-	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
+	if (dev->msix_cap) {
 		struct physdev_pci_device ppdev = {
 			.seg = pci_domain_nr(dev->bus),
 			.bus = dev->bus->number,
@@ -371,7 +371,7 @@ static int pcistub_init_device(struct pc
 	if (err)
 		goto config_release;
 
-	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
+	if (dev->msix_cap) {
 		struct physdev_pci_device ppdev = {
 			.seg = pci_domain_nr(dev->bus),
 			.bus = dev->bus->number,



