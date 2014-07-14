Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaGNOzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 10:55:43 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60613 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932202AbaGNOzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 10:55:35 -0400
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <devicetree@vger.kernel.org>, <linux-doc@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, <jg1.han@samsung.com>,
        <bhelgaas@google.com>, <mohit.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, <grant.likely@linaro.org>
Subject: [PATCH v2 0/4] dra7: Add PCIe support
Date: Mon, 14 Jul 2014 20:25:01 +0530
Message-ID: <1405349705-31400-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from v1:
* fixed dw_pcie_prog_viewport_io_outbound() to use untranslated address
* split dra7xx patch into driver part and documentation part

[1] is split into separate series in order for individual subsystem
Maintainers to pick up the patches. This series handles the PCIe
support for DRA7.

Rebased to pci -next.

[1] -> https://lkml.org/lkml/2014/5/29/258

Kishon Vijay Abraham I (4):
  PCI: designware: Configuration space should be specified in 'reg'
  PCI: designware: use untranslated address while programming ATU
  Documentation: pci: ti: Add dt binding documentation for PCIe in
    DRA7xx
  PCI: host: pcie-dra7xx: add support for pcie-dra7xx controller

 .../devicetree/bindings/pci/designware-pcie.txt    |    4 +
 Documentation/devicetree/bindings/pci/ti-pci.txt   |   59 +++
 drivers/pci/host/Kconfig                           |   10 +
 drivers/pci/host/Makefile                          |    1 +
 drivers/pci/host/pci-dra7xx.c                      |  458 ++++++++++++++++++++
 drivers/pci/host/pcie-designware.c                 |   72 ++-
 drivers/pci/host/pcie-designware.h                 |    4 +
 7 files changed, 592 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/pci/ti-pci.txt
 create mode 100644 drivers/pci/host/pci-dra7xx.c

-- 
1.7.9.5

