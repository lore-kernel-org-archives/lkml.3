Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070AbaCLSGa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 14:06:30 -0400
Received: from mail-yh0-f41.google.com ([209.85.213.41]:37780 "EHLO
	mail-yh0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755503AbaCLSG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 14:06:27 -0400
Date: Wed, 12 Mar 2014 12:06:18 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Bolle <pebolle@tiscali.nl>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Andreas Noever <andreas.noever@gmail.com>
Subject: [GIT PULL] PCI updates for v3.14
Message-ID: <20140312180618.GA11931@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

These are two important regression fixes for bugs we've introduced so far
in v3.14.

One of the resource allocation changes from the merge window is broken for
32-bit kernels where we don't use _CRS for PCI host bridges (mostly
pre-2008 machines), so there's a fix for that.

The INTx enable change we put in after the merge window turned out to break
pciehp because we re-enable INTx on the hotplug bridge, which apparently
breaks MSI for future hotplug events.

The following changes since commit fa389e220254c69ffae0d403eac4146171062d08:

  Linux 3.14-rc6 (2014-03-09 19:41:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/helgaas/pci.git tags/pci-v3.14-fixes-2

for you to fetch changes up to ac93ac7403493f8707b7734de9f40d5cb5db9045:

  PCI: Don't check resource_size() in pci_bus_alloc_resource() (2014-03-12 11:19:20 -0600)

----------------------------------------------------------------
PCI updates for v3.14:

  Resource management
    - Fix allocation from 0-4GB regions (Bjorn Helgaas)

  Miscellaneous
    - Enable INTx only when MSI/MSI-X not enabled (Bjorn Helgaas)

----------------------------------------------------------------
Bjorn Helgaas (2):
      PCI: Enable INTx in pci_reenable_device() only when MSI/MSI-X not enabled
      PCI: Don't check resource_size() in pci_bus_alloc_resource()

 drivers/pci/bus.c | 2 --
 drivers/pci/pci.c | 3 +++
 2 files changed, 3 insertions(+), 2 deletions(-)
