Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754463AbaBZXls (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:41:48 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:52958 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754430AbaBZXlp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:41:45 -0500
Subject: [PATCH 2/7] alpha/PCI: Use default pcibios_enable_device()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, linux-alpha@vger.kernel.org
Date: Wed, 26 Feb 2014 16:41:42 -0700
Message-ID: <20140226234142.18970.8692.stgit@bhelgaas-glaptop.roam.corp.google.com>
In-Reply-To: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
References: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need anything arch-specific in pcibios_enable_device(), so drop
the arch implementation and use the default generic one.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
CC: linux-alpha@vger.kernel.org
---
 arch/alpha/kernel/pci.c |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/arch/alpha/kernel/pci.c b/arch/alpha/kernel/pci.c
index edb4e0097b75..076c35cd6cde 100644
--- a/arch/alpha/kernel/pci.c
+++ b/arch/alpha/kernel/pci.c
@@ -254,12 +254,6 @@ void pcibios_fixup_bus(struct pci_bus *bus)
 	}
 }
 
-int
-pcibios_enable_device(struct pci_dev *dev, int mask)
-{
-	return pci_enable_resources(dev, mask);
-}
-
 /*
  *  If we set up a device for bus mastering, we need to check the latency
  *  timer as certain firmware forgets to set it properly, as seen

