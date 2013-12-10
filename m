Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3LJGyk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:54:40 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:51369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab3LJGyh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:54:37 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Guo Chao <yan@linux.vnet.ibm.com>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH v4 0/5] PCI: allocate 64bit mmio pref
Date: Mon,  9 Dec 2013 22:54:39 -0800
Message-Id: <1386658484-15774-1-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.8.4
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mmio 64 allocation that could help Guo Chao <yan@linux.vnet.ibm.com> on powerpc mmio allocation.
It will try to assign 64 bit resource above 4g at first.

And it is based on current pci/for-linus.

-v2: update after patch that move device_del down to pci_destroy_dev.
     add "Try best to allocate pref mmio 64bit above 4G"

-v3: refresh and send out after pci_clip_resource() changes,
     as Bjorn is not happy with attachments.

-v4: make pcibios_resource_to_bus take bus directly.

Yinghai Lu (5):
  PCI: pcibus address to resource converting take bus instead of dev
  PCI: Don't use 4G bus address directly in resource allocation
  PCI: Try to allocate mem64 above 4G at first
  PCI: Try best to allocate pref mmio 64bit above 4g
  PCI: Sort pci root bus resources list

 arch/alpha/kernel/pci-sysfs.c       |   4 +-
 arch/powerpc/kernel/pci-common.c    |   4 +-
 arch/powerpc/kernel/pci_of_scan.c   |   4 +-
 arch/sparc/kernel/pci.c             |   6 +-
 arch/x86/include/asm/pci.h          |   1 -
 drivers/pci/bus.c                   |  73 +++++++++++++++---
 drivers/pci/host-bridge.c           |  24 +++---
 drivers/pci/probe.c                 |  18 ++---
 drivers/pci/quirks.c                |   2 +-
 drivers/pci/rom.c                   |   2 +-
 drivers/pci/setup-bus.c             | 149 +++++++++++++++++++++++-------------
 drivers/pci/setup-res.c             |  16 +++-
 drivers/pcmcia/i82092.c             |   2 +-
 drivers/pcmcia/yenta_socket.c       |   6 +-
 drivers/scsi/sym53c8xx_2/sym_glue.c |   5 +-
 drivers/video/arkfb.c               |   2 +-
 drivers/video/s3fb.c                |   2 +-
 drivers/video/vt8623fb.c            |   2 +-
 include/linux/pci.h                 |   8 +-
 19 files changed, 217 insertions(+), 113 deletions(-)

-- 
1.8.4

