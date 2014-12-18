Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaLRWHh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 17:07:37 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43072 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaLRWHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 17:07:34 -0500
From: Murali Karicheri <m-karicheri2@ti.com>
To: <bhelgaas@google.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <devicetree@vger.kernel.org>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
CC: Murali Karicheri <m-karicheri2@ti.com>
Subject: [RFC v1 PATCH 0/2] PCI: get DMA configuration from parent device
Date: Thu, 18 Dec 2014 17:07:03 -0500
Message-ID: <1418940425-2017-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI devices on Keystone doesn't have correct dma_pfn_offset set. This patch
add capability to set the dma configuration such as dma-mask, dma_pfn_offset,
and dma ops etc using the same information from DT. The prior RFCs and
discussions are available at [1] and [2] below.

This patch make use of a recent dma API addeded to latest master and I could
only compile this as the latest kernel doesn't boot up on Keystone platforms.
So I am continue to send RFC version so that this gets a wider review before
sending the formal patch.

[2] : https://www.mail-archive.com/linux-kernel@vger.kernel.org/msg790244.html
[1] : http://www.gossamer-threads.com/lists/linux/kernel/2024591

Change history:
	v1 - updates based on the comments against initial RFC.
	   - Added a helper function to get the OF node of the parent
	   - Added an API in of_pci.c to update DMA configuration of the pci
	     device.

Murali Karicheri (2):
  of/pci: add of_pci_dma_configure() update dma configuration
  PCI: update dma configuration from DT

 drivers/of/of_pci.c    |   71 ++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/pci/probe.c    |    2 ++
 include/linux/of_pci.h |   12 ++++++++
 3 files changed, 85 insertions(+)

-- 
1.7.9.5

