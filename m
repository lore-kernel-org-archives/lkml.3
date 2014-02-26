Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbaBZXoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 18:44:38 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:46737 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366AbaBZXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 18:41:32 -0500
Subject: [PATCH 0/7] PCI: Use default pcibios_enable_device()
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 26 Feb 2014 16:41:29 -0700
Message-ID: <20140226233541.18970.83328.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several architectures implement a simple pcibios_enable_device() that looks
like this:

  int pcibios_enable_device(struct pci_dev *dev, int mask)
  {
         return pci_enable_resources(dev, mask);
  }

This puts a weak version of that in the PCI core and removes the
corresponding implementations from the architectures.

s390 is slightly less trivial but the same general idea.

I'd like to do the same for all the other architectures, but some (arm,
cris, m68k, mips, unicore32, xtensa, and parts of sparc and tile) don't
seem to use pci_claim_resource(), so BAR resource r->parent pointers
probably aren't set, so I can't change them yet.

---

Bjorn Helgaas (7):
      PCI: Add "weak" generic pcibios_enable_device() implementation
      alpha/PCI: Use default pcibios_enable_device()
      microblaze/PCI: Use default pcibios_enable_device()
      sh/PCI: Use default pcibios_enable_device()
      sparc/PCI: Use default pcibios_enable_device() (Leon only)
      tile PCI RC: Use default pcibios_enable_device()
      s390/PCI: Use generic pci_enable_resources()


 arch/alpha/kernel/pci.c          |    6 ------
 arch/microblaze/pci/pci-common.c |    5 -----
 arch/s390/pci/pci.c              |   13 +------------
 arch/sh/drivers/pci/pci.c        |    5 -----
 arch/sparc/kernel/leon_pci.c     |    5 -----
 arch/tile/kernel/pci_gx.c        |   12 ------------
 drivers/pci/pci.c                |    5 +++++
 7 files changed, 6 insertions(+), 45 deletions(-)
