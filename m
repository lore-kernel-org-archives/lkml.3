Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760531Ab3EBQHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 12:07:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62845 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760402Ab3EBQG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 12:06:59 -0400
Message-ID: <1367510747.22436.16.camel@ul30vt.home>
Subject: [GIT PULL] VFIO for v3.10
From: Alex Williamson <alex.williamson@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, kvm <kvm@vger.kernel.org>,
        "Pandarathil, Vijaymohan R" <vijaymohan.pandarathil@hp.com>,
        yongjun_wei@trendmicro.com.cn, Gavin Shan <shangw@linux.vnet.ibm.com>,
        wangyijing@huawei.com
Date: Thu, 02 May 2013 10:05:47 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the following tag for v3.10.  This should auto merge cleanly
to your current tree.  Thanks,

Alex

The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:

  Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)

are available in the git repository at:

  git://github.com/awilliam/linux-vfio.git tags/vfio-for-v3.10

for you to fetch changes up to 664e9386bd05dbdfecfb28d6cf2fde983aabc65c:

  vfio: Set container device mode (2013-04-30 15:42:28 -0600)

----------------------------------------------------------------
vfio updates for v3.10

Changes include extension to support PCI AER notification to userspace,
byte granularity of PCI config space and access to unarchitected PCI
config space, better protection around IOMMU driver accesses, default
file mode fix, and a few misc cleanups.

----------------------------------------------------------------
Alex Williamson (5):
      vfio-pci: Use byte granularity in config map
      vfio-pci: Enable raw access to unassigned config space
      vfio: Convert container->group_lock to rwsem
      vfio: Use down_reads to protect iommu disconnects
      vfio: Set container device mode

Vijay Mohan Pandarathil (2):
      VFIO: Wrapper for getting reference to vfio_device
      VFIO-AER: Vfio-pci driver changes for supporting AER

Wei Yongjun (1):
      vfio: make local function vfio_pci_intx_unmask_handler() static

Yijing Wang (1):
      PCI/VFIO: use pcie_flags_reg instead of access PCI-E Capabilities Register

 drivers/vfio/pci/vfio_pci.c         |  44 ++++++++-
 drivers/vfio/pci/vfio_pci_config.c  | 172 ++++++++++++++++++++----------------
 drivers/vfio/pci/vfio_pci_intrs.c   |  67 +++++++++++++-
 drivers/vfio/pci/vfio_pci_private.h |   1 +
 drivers/vfio/vfio.c                 | 117 ++++++++++++++++++------
 include/linux/vfio.h                |   3 +
 include/uapi/linux/vfio.h           |   1 +
 7 files changed, 298 insertions(+), 107 deletions(-)


