Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752053AbaLXWMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2014 17:12:25 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:44535 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaLXWMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2014 17:12:22 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <linux@arm.linux.org.uk>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <arnd@arndb.de>, <will.deacon@arm.com>,
        <grant.likely@linaro.org>, <robh+dt@kernel.org>,
        <devicetree@vger.kernel.org>, <bhelgaas@google.com>,
        <linux-pci@vger.kernel.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [PATCH v2 0/2] PCI: get DMA configuration from parent device
Date: Wed, 24 Dec 2014 17:11:37 -0500
Message-ID: <1419459099-6667-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
and dma ops etc using the information from DT. The prior RFCs and discussions
are available at [1] and [2] below.

[2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
[1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591

Change history:
	v2 - update size to coherent_dma_mask + 1 if dma-range info is missing
	   - also check the np for null.
	v1 - updates based on the comments against initial RFC.
	   - Added a helper function to get the OF node of the parent
	   - Added an API in of_pci.c to update DMA configuration of the pci
	     device.

Murali Karicheri (2):
  of/pci: add of_pci_dma_configure() update dma configuration
  PCI: update dma configuration from DT

 drivers/of/of_pci.c    |   73 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c    |    2 ++
 include/linux/of_pci.h |   12 ++++++++
 3 files changed, 87 insertions(+)

-- 
1.7.9.5

