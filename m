Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306AbaGHR5B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 13:57:01 -0400
Received: from mail.kernel.org ([198.145.19.201]:54825 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753747AbaGHR5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 13:57:00 -0400
From: konrad@kernel.org
To: xen-devel@lists.xenproject.org, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, linux-kernel@vger.kernel.org
Subject: [PATCH] Xen PCIbackend support for slot and bus reset (v3).
Date: Tue,  8 Jul 2014 14:58:22 -0400
Message-Id: <1404845909-13563-1-git-send-email-konrad@kernel.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches had been posted in the past and had been reworked
to address reviews. The original concerns with the patches was
the complex logic of doing an workqueue (or thread) that would
do the FLR/bus/slot reset outside the PCI lock. That idea proved
buggy. The other idea of usurping the 'reset' SysFS didn't work
either - as the the generic code will complain loudly about this.

The best so far mechanism is to use the 'xl' toolstack usage
of 'do_flr' and make that work in Xen pciback.

 Documentation/ABI/testing/sysfs-driver-pciback |   95 ++++++++++++++
 drivers/xen/xen-pciback/pci_stub.c             |  163 +++++++++++++++++++-----
 drivers/xen/xen-pciback/xenbus.c               |    2 +-
 3 files changed, 224 insertions(+), 36 deletions(-)

Konrad Rzeszutek Wilk (7):
      xen-pciback: Document the various parameters and attributes in SysFS
      xen/pciback: Don't deadlock when unbinding.
      xen/pciback: Move the FLR code to a function.
      xen/pciback: Implement PCI reset slot or bus with 'do_flr' SysFS attribute
      xen/pciback: Include the domain id if removing the device whilst still in use
      xen/pciback: Print out the domain owning the device.
      xen/pciback: Remove tons of dereferences

