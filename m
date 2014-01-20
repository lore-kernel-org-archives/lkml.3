Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752544AbaATWBp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 17:01:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41757 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750942AbaATWBm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 17:01:42 -0500
Subject: [PATCH 0/2] Quirk Intel PCH root ports for ACS-like features
From: Alex Williamson <alex.williamson@redhat.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 20 Jan 2014 15:01:40 -0700
Message-ID: <20140120215502.29567.11291.stgit@bling.home>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As described in 2/2 many Intel root ports lack PCIe ACS capabilities
which results in excessively large IOMMU groups.  Many of these root
ports do provide isolation capabilities, we just need to use device
specific mechanisms to enable and verify.  Long term, I hope we can
round out this list (particularly to include X79 root ports) and
more importantly, encourage proper PCIe ACS support in future
products.  I'm really hoping we can get this in during the 3.14 cycle.
Thanks,

Alex

---

Alex Williamson (2):
      pci: Add device specific PCI ACS enable
      pci/quirks: Enable quirks for PCIe ACS on Intel PCH root ports


 drivers/pci/pci.c    |   26 +++++-
 drivers/pci/quirks.c |  201 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/pci.h  |    2 
 3 files changed, 223 insertions(+), 6 deletions(-)
