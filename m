Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752216AbaLCVlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 16:41:12 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:33273 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751046AbaLCVlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 16:41:06 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, xen-devel@lists.xenproject.org,
        boris.ostrovsky@oracle.com, david.vrabel@citrix.com
Subject: [PATCH v5] Fixes for PCI backend for 3.19. 
Date: Wed,  3 Dec 2014 16:40:25 -0500
Message-Id: <1417642834-20350-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.9.3
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since v4 (http://lists.xen.org/archives/html/xen-devel/2014-11/msg02130.html):
 - Per David's review altered one of the patches.
v3 (https://lkml.org/lkml/2014/7/8/533):
 - Epic discussion.

These patches fix some issues with PCI back and also add proper
bus/slot reset.


 Documentation/ABI/testing/sysfs-driver-pciback |  12 ++
 drivers/pci/pci.c                              |   5 +-
 drivers/xen/xen-pciback/passthrough.c          |  14 +-
 drivers/xen/xen-pciback/pci_stub.c             | 236 +++++++++++++++++++++----
 drivers/xen/xen-pciback/pciback.h              |   7 +-
 drivers/xen/xen-pciback/vpci.c                 |  14 +-
 drivers/xen/xen-pciback/xenbus.c               |   4 +-
 include/linux/device.h                         |   5 +
 include/linux/pci.h                            |   2 +
 9 files changed, 254 insertions(+), 45 deletions(-)


Jan Beulich (1):
      xen-pciback: drop SR-IOV VFs when PF driver unloads

Konrad Rzeszutek Wilk (8):
      xen/pciback: Don't deadlock when unbinding.
      driver core: Provide an wrapper around the mutex to do lockdep warnings
      xen/pciback: Include the domain id if removing the device whilst still in use
      xen/pciback: Print out the domain owning the device.
      xen/pciback: Remove tons of dereferences
      PCI: Expose pci_load_saved_state for public consumption.
      xen/pciback: Restore configuration space when detaching from a guest.
      xen/pciback: Implement PCI reset slot or bus with 'do_flr' SysFS attribute

