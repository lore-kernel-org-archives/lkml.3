Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328AbaCGO54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 09:57:56 -0500
Received: from mga02.intel.com ([134.134.136.20]:9102 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751953AbaCGO5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 09:57:55 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,608,1389772800"; 
   d="scan'208";a="468423422"
From: Mathias Nyman <mathias.nyman@linux.intel.com>
To: <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <sarah.a.sharp@linux.intel.com>, <stern@rowland.harvard.edu>,
        Mathias Nyman <mathias.nyman@linux.intel.com>
Subject: [PATCH 0/2] xhci, usbnet: fixes for 3.14 
Date: Fri,  7 Mar 2014 17:06:56 +0200
Message-Id: <1394204818-25323-1-git-send-email-mathias.nyman@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

These two xhci scatter-gather related patches should be reverted to avoid
USB 3.0 mass storage regression for users.
Sarah and Alan concluded that this the best choice until proper TD fragmentation
rules are implemented, discussion is here:  

http://marc.info/?l=linux-usb&m=139395884021971&w=2

The patch xhci 1.0: "Limit arbitrarily-aligned scatter gather." was added
to 3.14-rc1 and stable, both patches should be reverted from stable and 3.14

A few mass storage regression cases:
http://marc.info/?l=linux-usb&m=139413069718354&w=2
http://marc.info/?l=linux-usb&m=139411871213253&w=2
http://marc.info/?l=linux-usb&m=139361293103188&w=2

-Mathias

Mathias Nyman (2):
  Revert "xhci 1.0: Limit arbitrarily-aligned scatter gather."
  Revert "USBNET: ax88179_178a: enable tso if usb host supports sg dma"

 drivers/net/usb/ax88179_178a.c |  8 --------
 drivers/usb/host/xhci.c        | 14 +++-----------
 2 files changed, 3 insertions(+), 19 deletions(-)

-- 
1.8.1.2

