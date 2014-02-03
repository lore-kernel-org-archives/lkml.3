Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417AbaBCV1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 16:27:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41145 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753008AbaBCV1b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 16:27:31 -0500
Subject: [PATCH v2 0/3] Quirk Intel PCH root ports for ACS-like features
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 03 Feb 2014 14:27:27 -0700
Message-ID: <20140203212216.8607.68273.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:
 - Remove bus #0 bug in filtering matching
 - Add 2/3 introducing PCI_DEV_FLAGS_ACS_ENABLED_QUIRK, this gives
   is better tracking and addresses the theoretical hotplug issue
 - Update 3/3 for PCI_DEV_FLAGS_ACS_ENABLED_QUIRK
 - Add dev_info to print regardless of whether we changes bits
 - Add Intel cc

As described in 3/3 many Intel root ports lack PCIe ACS capabilities
which results in excessively large IOMMU groups.  Many of these root
ports do provide isolation capabilities, we just need to use device
specific mechanisms to enable and verify.  Long term, I hope we can
round out this list (particularly to include X79 root ports) and
more importantly, encourage proper PCIe ACS support in future
products.  I'm really hoping we can get this in during the 3.14 cycle.
Thanks,

Alex
---

Alex Williamson (3):
      pci: Add device specific PCI ACS enable
      pci: Add pci_dev_flag for ACS enable quirks
      pci/quirks: Enable quirks for PCIe ACS on Intel PCH root ports


 drivers/pci/pci.c    |   26 +++++--
 drivers/pci/quirks.c |  185 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |    4 +
 3 files changed, 209 insertions(+), 6 deletions(-)
