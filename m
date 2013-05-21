Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753908Ab3EUKkq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 06:40:46 -0400
Received: from mga14.intel.com ([143.182.124.37]:51966 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752391Ab3EUKko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 06:40:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,713,1363158000"; 
   d="scan'208";a="305622736"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: linux-usb@vger.kernel.org
Cc: <sarah.a.sharp@intel.com>, <linux-kernel@vger.kernel.org>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [RFC PATCH v2 0/4] Add usb2 link powermanagement BESL support
Date: Tue, 21 May 2013 13:43:33 +0300
Message-Id: <1369133017-3035-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series adds usb2 best effort service latency (BESL) link PM support                                   
to xHCI. BESL is an updated alternative to host initated resume delay                                      
(HIRD) method of describing idle link timeouts.                                                            
                                                                                                           
Additionally this series fixes port capability checking                                                    
and replaces magic numbers with port register names.      

Changes since v1:
-Use kstrto* and unsigned values in sysfs functions as Alan Stern suggested

Mathias Nyman (4):
  usb: xhci: check usb2 port capabilities before adding hw link PM
    support
  usb: xhci: define port register names and use them instead of magic
    numbers
  usb: xhci: add USB2 Link power management BESL support
  usb: add usb2 Link PM variables to sysfs and usb_device

 drivers/usb/core/sysfs.c         |   54 +++++++++
 drivers/usb/host/xhci-ext-caps.h |    1 +
 drivers/usb/host/xhci-hub.c      |   16 +--
 drivers/usb/host/xhci-mem.c      |   33 +++++-
 drivers/usb/host/xhci.c          |  234 +++++++++++++++++++++++++++-----------
 drivers/usb/host/xhci.h          |   31 +++++
 include/linux/usb.h              |   19 +++
 7 files changed, 308 insertions(+), 80 deletions(-)

-- 
1.7.4.1

