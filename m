Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab3AODia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 22:38:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5379 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755279Ab3AODi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 22:38:28 -0500
Subject: [PATCH 0/3] vfio-pci: VGA and legacy MMIO & I/O port access
To: alex.williamson@redhat.com
From: Alex Williamson <alex.williamson@redhat.com>
Cc: aik@ozlabs.ru, benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, david@gibson.dropbear.id.au
Date: Mon, 14 Jan 2013 20:38:17 -0700
Message-ID: <20130115033101.6894.50292.stgit@bling.home>
User-Agent: StGit/0.16
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series includes a couple cleanups that I'll target for 3.9 plus
RFC patch 3/3 that adds device regions for legacy I/O and makes use
of the VGA arbiter for enabling VGA assignment.  I know the POWER
guys don't likely care about VGA support, but Alexey, Ben, and David,
I'd appreciate any feedback on the overal incorporation into vfio
given your history with the design.  VGA is still a work in progress
but with this base I'm able to assign a handlful of desktop cards that
I have on hand to a qemu guest using standard builtin VGA drivers.
Thanks,

Alex

---

Alex Williamson (3):
      vfio-pci: Cleanup read/write functions
      vfio-pci: Cleanup BAR access
      vfio-pci: Add support for legacy MMIO & I/O port towards VGA support


 drivers/vfio/pci/Kconfig            |   10 +
 drivers/vfio/pci/vfio_pci.c         |  106 +++++++++----
 drivers/vfio/pci/vfio_pci_config.c  |    5 -
 drivers/vfio/pci/vfio_pci_private.h |   16 +-
 drivers/vfio/pci/vfio_pci_rdwr.c    |  282 +++++++++++++++++------------------
 include/uapi/linux/vfio.h           |    8 +
 6 files changed, 242 insertions(+), 185 deletions(-)
