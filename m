Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757499Ab3GLJgv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 05:36:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:51653 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab3GLJgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 05:36:50 -0400
From: Yijing Wang <wangyijing@huawei.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: <linux-kernel@vger.kernel.org>, Don Dutile <ddutile@redhat.com>,
        Paul Bolle <pebolle@tiscali.nl>, <linux-pci@vger.kernel.org>,
        Rafael <rjw@sisk.pl>, Hanjun Guo <guohanjun@huawei.com>,
        <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>
Subject: [PATCH -v3 0/3] Use PCIe DSN to improve pciehp_resume
Date: Fri, 12 Jul 2013 17:32:20 +0800
Message-ID: <1373621543-54836-1-git-send-email-wangyijing@huawei.com>
X-Mailer: git-send-email 1.7.11.msysgit.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2->v3: add a wrap function pci_dsn_init, fix other typo error and git am error.
		Thanks for Don Dutile and Paul Bolle 's review,comments and test.
v1->v2: Modify pci_get_dsn to pci_device_serial_number,
	    power off slot before remove the old device during resume to avoid
		old .remove() method to touch new hardware.
		Fix other typo and fail check problems.
		Split the list_empty() guard into new patch.
		Thanks for Bjorn's review and comments.

This series applied to Bjorn's pci-next branch.

Yijing Wang (3):
  PCI: introduce PCIe Device Serial Number Capability support
  PCI,pciehp: avoid add a device already exist before suspend during
    resume
  PCI,pciehp: use PCIe DSN to identify device change during suspend

 drivers/pci/hotplug/pciehp_core.c |   55 +++++++++++++++++++++++++++++++++++--
 drivers/pci/pci.c                 |   30 ++++++++++++++++++++
 drivers/pci/pci.h                 |    1 +
 drivers/pci/probe.c               |    2 +
 include/linux/pci.h               |    3 ++
 5 files changed, 88 insertions(+), 3 deletions(-)


