Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751410AbaKFDBR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 22:01:17 -0500
Received: from mga03.intel.com ([134.134.136.65]:22841 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750905AbaKFDBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 22:01:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="484936952"
From: Lu Baolu <baolu.lu@linux.intel.com>
To: Mathias Nyman <mathias.nyman@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lu Baolu <baolu.lu@linux.intel.com>
Subject: [PATCH v4 0/3] Rework "xhci: clear root port wake on bits if controller isn't wake-up capable"
Date: Thu,  6 Nov 2014 10:50:50 +0800
Message-Id: <1415242253-72501-1-git-send-email-baolu.lu@linux.intel.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serie of patch reworks commit ff8cbf250b448aac35589f6075082c3fcad8a8fe.
This has been discussed at http://www.spinics.net/lists/linux-usb/msg114986.html
It also includes a patch to fix a comment in drivers/usb/host/xhci.h.

Changes in v4:
	- Refine xhci_disable_port_wake_on_bits().
	- Add "Acked-by: Alan Stern"

Changes in v3:
	- Need to consider run-time suspend as well.
	- Change "wake-up capable" to "allowed to do wakeup"
	    in both comments and patch description.
	- Add "Suggested-by: Alan Stern"

Changes in v2:
	- Should not be a quirk.
	- Should be applied to all xhci controllers.

Lu Baolu (3):
  usb: xhci: Revert "xhci: clear root port wake on bits if controller
    isn't wake-up capable"
  usb: xhci: This reworks ff8cbf250b448aac35589f6075082c3fcad8a8fe
  usb: xhci: fix comment for PORT_DEV_REMOVE

 drivers/usb/host/xhci-hub.c  |  5 +----
 drivers/usb/host/xhci-pci.c  |  2 +-
 drivers/usb/host/xhci-plat.c | 10 +++++++++-
 drivers/usb/host/xhci.c      | 42 +++++++++++++++++++++++++++++++++++++++++-
 drivers/usb/host/xhci.h      |  4 ++--
 5 files changed, 54 insertions(+), 9 deletions(-)

-- 
1.9.1

