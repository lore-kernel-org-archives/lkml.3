Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529AbaBZXmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:42:08 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:51001 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515AbaBZXmF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:42:05 -0500
Subject: [PATCH 5/7] sparc/PCI: Use default pcibios_enable_device() (Leon
 only)
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Daniel Hellstrom <daniel@gaisler.com>, linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 16:42:02 -0700
Message-ID: <20140226234202.18970.64592.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need anything arch-specific in pcibios_enable_device() so drop
the arch implementation and use the default generic one.

Note that sparc has two pcibios_enable_device() implementations other than
the one removed here.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: Daniel Hellstrom <daniel@gaisler.com
---
 arch/sparc/kernel/leon_pci.c |    5 -----
 1 file changed, 5 deletions(-)

diff --git a/arch/sparc/kernel/leon_pci.c b/arch/sparc/kernel/leon_pci.c
index 88aaaa57bb64..e16c4157e1ae 100644
--- a/arch/sparc/kernel/leon_pci.c
+++ b/arch/sparc/kernel/leon_pci.c
@@ -99,11 +99,6 @@ resource_size_t pcibios_align_resource(void *data, const struct resource *res,
 	return res->start;
 }
 
-int pcibios_enable_device(struct pci_dev *dev, int mask)
-{
-	return pci_enable_resources(dev, mask);
-}
-
 /* in/out routines taken from pcic.c
  *
  * This probably belongs here rather than ioport.c because

