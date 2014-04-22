Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaDVMMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:12:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:4921 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbaDVMMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,903,1389772800"; 
   d="scan'208";a="421964513"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <sarah.a.sharp@linux.intel.com>,
        <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 0/5] xhci: fixes for 3.15-rc usb-linus
Date: Tue, 22 Apr 2014 15:22:57 +0300
Message-Id: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

Here are the xhci fixes for 3.15-rc usb-linus.
Most of them are very small fixes that didn't make
it to 3.14, sitting and waiting for 3.15-rc1 to come out.

Only the "Prefer endpoint context.." patch  by Julius has a bit more content.
 
These patches are picked together with Sarah, they are tested on top of
3.15-rc1, and apply on your current usb-linus branch

-Mathias 

Alexander Gordeev (1):
  xhci: Use pci_enable_msix_exact() instead of pci_enable_msix()

David Cohen (1):
  usb/xhci: fix compilation warning when !CONFIG_PCI && !CONFIG_PM

Denis Turischev (1):
  xhci: Switch Intel Lynx Point ports to EHCI on shutdown.

Igor Gnatenko (1):
  xhci: extend quirk for Renesas cards

Julius Werner (1):
  usb: xhci: Prefer endpoint context dequeue pointer over stopped_trb

 drivers/usb/host/xhci-pci.c  |  6 ++--
 drivers/usb/host/xhci-ring.c | 67 ++++++++++++++++++++------------------------
 drivers/usb/host/xhci.c      |  9 +++---
 drivers/usb/host/xhci.h      |  2 --
 4 files changed, 38 insertions(+), 46 deletions(-)

-- 
1.8.3.2

