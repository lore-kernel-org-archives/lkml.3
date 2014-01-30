Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaA3TUi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 14:20:38 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:49222 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753400AbaA3TUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 14:20:33 -0500
Subject: [PATCH 0/2] Remove dead code
To: linux-pci@vger.kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: e1000-devel@lists.sourceforge.net,
        Stephen Hemminger <stephen@networkplumber.org>,
        Arjan van de Ven <arjan@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Thu, 30 Jan 2014 12:20:31 -0700
Message-ID: <20140130192011.25426.45702.stgit@bhelgaas-glaptop.roam.corp.google.com>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a rework of part of Stephen's patch [1].

This removes the MMIO exclusivity support that was added as part of an
e1000e bug hunt.

The e1000e driver still uses pci_request_selected_regions_exclusive(), but
there are no callers of pci_request_region_exclusive() and
pci_request_regions_exclusive().  I thought it was cleaner to remove the
whole thing than to leave parts of it in place.  But I could easily be
convinced to leave part or all of this in place if people think it's still
useful.

It also removes SR-IOV migration support, which is completely unused, as
far as I can tell.

[1] http://lkml.kernel.org/r/20131227132710.7190647c@nehalam.linuxnetplumber.net

---

Bjorn Helgaas (2):
      PCI: Remove unused MMIO exclusivity support
      PCI: Remove unused SR-IOV VF Migration support


 Documentation/PCI/pci-iov-howto.txt        |    4 -
 Documentation/kernel-parameters.txt        |    4 -
 arch/x86/mm/init.c                         |    2 
 drivers/net/ethernet/intel/e1000e/netdev.c |    3 -
 drivers/pci/iov.c                          |  119 ----------------------------
 drivers/pci/pci-sysfs.c                    |    3 -
 drivers/pci/pci.c                          |  112 +++-----------------------
 drivers/pci/pci.h                          |    4 -
 include/linux/ioport.h                     |    5 -
 include/linux/pci.h                        |    7 --
 kernel/resource.c                          |   54 -------------
 11 files changed, 14 insertions(+), 303 deletions(-)
