Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754904Ab3CVIwA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 04:52:00 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55033 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab3CVIvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 04:51:50 -0400
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [RFC 0/2] PCI: Introduce MSI chip infrastructure
Date: Fri, 22 Mar 2013 09:51:45 +0100
Message-Id: <1363942307-9327-1-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.5
X-Provags-ID: V02:K0:ifhjgdPKBFZmAZFKF4O38gYOkeWoPGqcBevDDHsxfE0
 ZNPakr4dHzdGU1YSLlU6DdKpqGGKlnuBCLlEVzL6SKYnc0PlVI
 YQ+PBoUWQRffXuBpm7M2tpghrhR+tw78wUJD8Scl57/SNe2sg/
 0srb9sAa7bruHeYgErPpscJRAP9w3mpPz8MC+ZsFfpWmgCwGsu
 3bkEWYKARru2lSdRWNbT1abGBcwz60lxGSEZX5UvmeZ1jJ+yG8
 W8zNyGoD8FibK+wRHwQELCDf28YjDHcCyvBYL4aoAKHDOaIweg
 ZkQwy4RTua554MmZ45mbaM9nS96xcFJeZHoq9NrMiD/dHbro2/
 EqT2L1hEpuvK4J1nBFQV6mpNQq6C16jd06ZlTYCT20yZAAeYeG
 789MTqKvkJ+siSrPQAsTtX5T4syQIARQIZ9sG0oNFFn6OqQ0ac
 hwDy/
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This pair of patches introduces a new MSI chip infrastructure aimed at
replacing the current per-architecture implementation of the MSI support
functions. The rationale being that for multi-platform support on ARM
(and of course other architectures as well) per-architecture hooks no
longer work, given that more than one implementation will be provided.

The approach chosen in this patch series is to introduce a new structure
called struct msi_chip that contains pointers to the functions that have
previously been implemented on a per-architecture basis. A pointer to
this structure is embedded with each struct pci_bus, similar to struct
pci_ops, and automatically passed to child busses during enumeration. It
is the responsibility of the PCI host bridge driver to setup the MSI
chip for the root bus.

An example for the usage of this new infrastructure is provided in the
second patch, which implements this for the Tegra PCIe controller
driver. Note that this driver has not been merged yet because this MSI
infrastructure is a prerequisite. Nevertheless it should serve as a
reference for implementors on how to use the MSI chip.

Thierry

Thierry Reding (2):
  PCI: Introduce new MSI chip infrastructure
  PCI: tegra: Use new MSI chip infrastructure

 drivers/pci/host/pci-tegra.c | 105 ++++++++++++++++++++++++-------------------
 drivers/pci/msi.c            |  35 +++++++++++++--
 drivers/pci/probe.c          |   1 +
 include/linux/msi.h          |  10 +++++
 include/linux/pci.h          |   1 +
 5 files changed, 103 insertions(+), 49 deletions(-)

-- 
1.8.1.5

