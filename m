Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755225AbaEHQPs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 12:15:48 -0400
Received: from mga11.intel.com ([192.55.52.93]:34560 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753452AbaEHQPr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 12:15:47 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1010,1389772800"; 
   d="scan'208";a="535979551"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 00/10] xhci: features for usb-next
Date: Thu,  8 May 2014 19:25:53 +0300
Message-Id: <1399566363-25837-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg

These following xhci patches are for usb-next and hopefully for 3.16

This patcheseries includes a bigger change in xhci command queue code,
(last four patches), a task that I've been working on for a longer time.
Sarah gave green light for v5 before she went on her sabbatical.

http://marc.info/?l=linux-usb&m=139889908701592&w=2

-Mathias

Alexander Gordeev (1):
  xhci: Use pci_enable_msix_exact() instead of pci_enable_msix()

Dan Williams (2):
  xhci: 'noxhci_port_switch' kernel parameter
  usb: catch attempts to submit urbs with a vmalloc'd transfer buffer

Fabio Estevam (1):
  usb: xhci: Use IS_ENABLED() macro

Lin Wang (1):
  xhci: fix wrong port number reported when setting USB2.0 hardware LPM.

Mathias Nyman (4):
  xhci: Use command structures when queuing commands on the command ring
  xhci: Add a global command queue
  xhci: Use completion and status in global command queue
  xhci: rework command timeout and cancellation,

Sarah Sharp (1):
  xhci: Report max device limit when Enable Slot command fails.

 Documentation/kernel-parameters.txt |   3 +
 drivers/usb/core/hcd.c              |   3 +
 drivers/usb/host/pci-quirks.c       |  15 +-
 drivers/usb/host/xhci-hub.c         |  43 ++-
 drivers/usb/host/xhci-mem.c         |  17 +-
 drivers/usb/host/xhci-ring.c        | 587 ++++++++++++++----------------------
 drivers/usb/host/xhci.c             | 271 +++++++++--------
 drivers/usb/host/xhci.h             |  47 +--
 8 files changed, 440 insertions(+), 546 deletions(-)

-- 
1.8.3.2

