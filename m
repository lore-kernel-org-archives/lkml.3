Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaKOKuL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 05:50:11 -0500
Received: from inca-roads.misterjones.org ([213.251.177.50]:50626 "EHLO
	inca-roads.misterjones.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752546AbaKOKtj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 05:49:39 -0500
From: Marc Zyngier <marc.zyngier@arm.com>
To: Thomas Gleixner <tglx@linutronix.de>,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Yingjoe Chen <yingjoe.chen@mediatek.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH 0/2] Stacked domains and MSI improvements
Date: Sat, 15 Nov 2014 10:49:11 +0000
Message-Id: <1416048553-29289-1-git-send-email-marc.zyngier@arm.com>
X-Mailer: git-send-email 2.1.0
X-SA-Exim-Connect-IP: 90.219.10.17
X-SA-Exim-Rcpt-To: tglx@linutronix.de, jiang.liu@linux.intel.com, yingjoe.chen@mediatek.com, bhelgaas@google.com, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-SA-Exim-Mail-From: marc.zyngier@arm.com
X-SA-Exim-Scanned: No (on cheepnis.misterjones.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This short series builds upon Jiang Liu's MSI stacked domain and tries
to clean up a couple of points:

- Patch 1 allows an msi_chip to carry a pointer to its irq domain.
  When populated by the MSI driver, this allow the PCI bus to be
  associated with an irq domain, removing most of the need for arch
  specific code in the case of multiple PCI busses.

- Patch 2 tries to work around a limitation of __irq_set_handler when
  called with an interrupt belongging to a stacked domain.

This has been tested on arm64, together with the GICv3 ITS.

Marc Zyngier (2):
  PCI/MSI: Allow an msi_chip to be associated to an irq domain
  genirq: Work around __irq_set_handler vs stacked domains ordering
    issues

 drivers/pci/msi.c   | 16 +++++++++++++++-
 include/linux/msi.h |  3 +++
 kernel/irq/chip.c   | 11 ++++++++++-
 3 files changed, 28 insertions(+), 2 deletions(-)

-- 
2.1.0

