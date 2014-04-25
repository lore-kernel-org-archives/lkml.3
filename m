Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaDYIIW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 04:08:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14424 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752389AbaDYIFU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 04:05:20 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Mitch Williams <mitch.a.williams@intel.com>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Linux NICS <linux.nics@intel.com>, e1000-devel@lists.sourceforge.net,
        Dept-HSGLinuxNICDev@qlogic.com, netdev@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: [PATCH net-next 0/2] Use pci_enable_msix_range() instead of pci_enable_msix()
Date: Fri, 25 Apr 2014 10:06:23 +0200
Message-Id: <cover.1398412015.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

The series completes converison of network drivers to the new
MSI initialization API.

As result of deprecation of MSI-X/MSI enablement functions
pci_enable_msix() and pci_enable_msi_block() all drivers
using these two interfaces need to be updated to use the
new pci_enable_msi_range()  or pci_enable_msi_exact()
and pci_enable_msix_range() or pci_enable_msix_exact()
interfaces.

Thanks!

Cc: Mitch Williams <mitch.a.williams@intel.com>
Cc: Jesse Brandeburg <jesse.brandeburg@intel.com>
Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
Cc: Linux NICS <linux.nics@intel.com>
Cc: e1000-devel@lists.sourceforge.net
Cc: Dept-HSGLinuxNICDev@qlogic.com
Cc: netdev@vger.kernel.org
Cc: linux-pci@vger.kernel.org

Alexander Gordeev (2):
  i40evf: Use pci_enable_msix_range() instead of pci_enable_msix()
  qlcnic: Use pci_enable_msix_exact() instead of pci_enable_msix()

 drivers/net/ethernet/intel/i40evf/i40evf_main.c  |   31 ++++++++--------------
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    4 +-
 2 files changed, 13 insertions(+), 22 deletions(-)

-- 
1.7.7.6

