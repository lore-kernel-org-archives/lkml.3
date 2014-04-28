Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074AbaD1UbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 16:31:11 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:35153 "EHLO
	alan.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757059AbaD1UbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 16:31:10 -0400
X-Greylist: delayed 456 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Apr 2014 16:31:09 EDT
Subject: [PATCH] pci: Allow very large resource windows
To: bhelgaas@google.com, linux-kernel@vger.kernel.org
From: Alan <gnomes@lxorguk.ukuu.org.uk>
Date: Mon, 28 Apr 2014 21:23:35 +0100
Message-ID: <20140428202321.8753.31852.stgit@alan.etchedpixels.co.uk>
User-Agent: StGit/0.15
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
index 138bdd6..5679ec2 100644
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

