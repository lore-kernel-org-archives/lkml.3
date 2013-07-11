Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab3GKJpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jul 2013 05:45:38 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:1926 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab3GKJph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jul 2013 05:45:37 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH -v2 0/3] Use PCIe DSN to improve pciehp_resume
Date: Thu, 11 Jul 2013 17:43:42 +0800
Message-ID: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v1->v2: Modify pci_get_dsn to pci_device_serial_number,
	    power off slot before remove the old device during resume to avoid
		old .remove() method to touch new hardware.
		Fix other typo and fail check problems.
		Split the list_empty() guard into new patch.
		

Yijing Wang (3):
  PCI: introduce PCIe Device Serial Number Capability support
  PCI,pciehp: avoid add a device already exist before suspend during
    resume
  PCI,pciehp: use PCIe DSN to identify device change during suspend

 drivers/pci/hotplug/pciehp_core.c |   54 ++++++++++++++++++++++++++++++++++--
 drivers/pci/pci.c                 |   27 ++++++++++++++++++
 drivers/pci/probe.c               |    2 +
 include/linux/pci.h               |    3 ++
 4 files changed, 83 insertions(+), 3 deletions(-)


