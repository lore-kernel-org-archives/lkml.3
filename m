Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760822AbaJ3R4v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:56:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759946AbaJ3R4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:56:47 -0400
Subject: [PATCH 3/3] PCI: Add a informational printk for invalid BARs
From: Myron Stowe <myron.stowe@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: willy@linux.intel.com, unruh@physics.ubc.ca, linux-kernel@vger.kernel.org,
        martin@lucina.net
Date: Thu, 30 Oct 2014 11:54:50 -0600
Message-ID: <20141030175450.22238.79504.stgit@amt.stowe>
In-Reply-To: <20141030175430.22238.47671.stgit@amt.stowe>
References: <20141030175430.22238.47671.stgit@amt.stowe>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a consequence of restoring the detection of invalid BARs, add a new
informational printk like the following when such occurrences are
encountered.

  pci ssss:bb:dd.f: [Firmware Bug]: reg 0xXX: invalid BAR (can't size)

Reported-by: William Unruh <unruh@physics.ubc.ca>
Reported-by: Martin Lucina <martin@lucina.net>
Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
---
 drivers/pci/probe.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
index 5c13279..2953c1d 100644
--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -271,8 +271,11 @@ int __pci_read_base(struct pci_dev *dev, enum pci_bar_type type,
 
 	sz64 = pci_size(l64, sz64, mask64);
 
-	if (!sz64)
+	if (!sz64) {
+		dev_info(&dev->dev, "%sreg 0x%x: invalid BAR (can't size)\n",
+			 FW_BUG, pos);
 		goto fail;
+	}
 
 	region.start = l64;
 	region.end = l64 + sz64;

