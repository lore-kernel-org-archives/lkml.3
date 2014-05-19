Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638AbaESNDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:03:18 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:33685 "EHLO
	alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753570AbaESNDR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:03:17 -0400
Subject: [PATCH] pci: Allow very large resource windows
From: Alan <gnomes@lxorguk.ukuu.org.uk>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 19 May 2014 14:03:14 +0100
Message-ID: <20140519130255.15364.49358.stgit@alan.etchedpixels.co.uk>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan <alan@linux.intel.com>

This is needed for some of the Xeon Phi type systems.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/pci/setup-bus.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index d219d44..4184112 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -921,7 +921,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 {
 	struct pci_dev *dev;
 	resource_size_t min_align, align, size, size0, size1;
-	resource_size_t aligns[12];	/* Alignments from 1Mb to 2Gb */
+	resource_size_t aligns[14];	/* Alignments from 1Mb to 8Gb */
 	int order, max_order;
 	struct resource *b_res = find_free_bus_resource(bus, type);
 	unsigned int mem64_mask = 0;
@@ -960,7 +960,7 @@ static int pbus_size_mem(struct pci_bus *bus, unsigned long mask,
 			/* For bridges size != alignment */
 			align = pci_resource_alignment(dev, r);
 			order = __ffs(align) - 20;
-			if (order > 11) {
+			if (order > 13) {
 				dev_warn(&dev->dev, "disabling BAR %d: %pR "
 					 "(bad alignment %#llx)\n", i, r,
 					 (unsigned long long) align);

