Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751820AbaBNAug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 19:50:36 -0500
Received: from mail-ob0-f176.google.com ([209.85.214.176]:63874 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750932AbaBNAuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 19:50:35 -0500
MIME-Version: 1.0
In-Reply-To: <1391643656.1067.1.camel@artifact>
References: <1390773698.3450.12.camel@artifact>
	<CAE9FiQVD=oVHM5WJgSJ5cNpXZ1NYy9E_pcGWfjKnmD9OZoHHsw@mail.gmail.com>
	<1391643656.1067.1.camel@artifact>
Date: Thu, 13 Feb 2014 16:50:34 -0800
X-Google-Sender-Auth: Ihfjzx26mC_8Ivye5VH-cHMmQEI
Message-ID: <CAE9FiQV8jutRhaBicL4kjqVYd07FzHmNoSN3NxdA2TYvOc_KUg@mail.gmail.com>
Subject: Re: pci-3.14 resource alloc
From: Yinghai Lu <yinghai@kernel.org>
To: Steven Newbury <steve@snewbury.org.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steven,

I just rebased all my pci patches (busn_alloc and resource allocation)
on top Linus
tree and Bjorn's pci/next.

Please check them at
git://git.kernel.org/pub/scm/linux/kernel/git/yinghai/linux-yinghai.git
for-pci-3.15

Let me know if it still works for your setup.

Thanks

Yinghai

Yinghai Lu (28):
  PCI: Try best to allocate pref mmio 64bit above 4g
  PCI, EDAC: fix ordering assign resource and bus_add
  PCI, sysfs: Clean up rescan with schedule_callback
  PCI: Rescan bus using callback method too
  PCI, sysfs: Clean up rescan with schedule_callback
  resources: Split out __allocate_resource()
  resources: Add resource_shrink_parents_top()
  resources: Add probe_resource()
  resources: Replace registered resource in tree.
  PCI: Add pci_bus_extend/shrink_top()
  PCI: Probe safe range that we can use for unassigned bridge.
  PCI: Add pci_bus_replace_busn_res()
  PCI: Allocate bus range instead of use max blindly
  PCI: Strict checking of valid range for bridge
  PCI: Kill pci_fixup_parent_subordinate_busnr()
  PCI: Seperate child bus scanning to two passes overall
  pcmcia: Remove workaround for fixing pci parent bus subordinate
  PCI, pciehp: Remove not needed bus number range checking
  PCI: More strict checking of valid range for bridge
  PCI: Don't shrink too much for hotplug bridge
  PCI: Keep more big bus range for sriov
  PCI: Allocate resource with big size at first when alignment is the same
  resource: Make find_resource could return just fit resource
  resource: Add allocate_resource_fit()
  PCI: Don't allocate small resource in big empty space.
  resource: Only return range with needed align
  PCI: Sort unassigned resources with correct alignment
  PCI, x86: Add pci=assign_pref_bars to realloc pref bars

 arch/x86/include/asm/pci_x86.h |   1 +
 arch/x86/pci/common.c          |   3 +
 arch/x86/pci/i386.c            |  21 ++-
 drivers/edac/i82875p_edac.c    |   3 +-
 drivers/pci/bus.c              |  33 +++--
 drivers/pci/hotplug-pci.c      |  12 +-
 drivers/pci/pci-sysfs.c        |  41 ++++--
 drivers/pci/probe.c            | 321 ++++++++++++++++++++++++++++++-----------
 drivers/pci/remove.c           |  35 +++++
 drivers/pci/setup-bus.c        | 190 ++++++++++++++++--------
 drivers/pci/setup-res.c        |  48 ++++--
 drivers/pcmcia/yenta_socket.c  |  75 ----------
 include/linux/ioport.h         |  15 ++
 include/linux/pci.h            |  11 ++
 kernel/resource.c              | 300 ++++++++++++++++++++++++++++++++++++--
 15 files changed, 828 insertions(+), 281 deletions(-)
