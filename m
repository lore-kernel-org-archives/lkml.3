Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932673AbaAaPkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 10:40:12 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41061 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754221AbaAaPkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 10:40:08 -0500
Date: Fri, 31 Jan 2014 10:38:57 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: boris.ostrovsky@oracle.com, david.vrabel@citrix.com,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [GIT PULL] (xen) stable/for-linus-3.14-rc0-late-tag
Message-ID: <20140131153857.GD22527@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.14-rc0-late-tag

which has bug-fixes for the new features that were added during this
cycle. There are also two fixes for long-standing issues for which we have
a solution: grant-table operations extra work that was not needed causing
performance issues and the self balloon code was too aggressive causing
OOMs.

The signed tag has a good description of what these fixes are.

Please pull!


 arch/arm/Kconfig                    |  1 +
 arch/arm/xen/enlighten.c            | 77 ++++++++++++++++++------------
 arch/x86/include/asm/xen/page.h     |  5 +-
 arch/x86/xen/grant-table.c          |  3 +-
 arch/x86/xen/p2m.c                  | 17 +------
 drivers/block/xen-blkback/blkback.c | 15 +++---
 drivers/xen/gntdev.c                | 13 +++--
 drivers/xen/grant-table.c           | 95 ++++++++++++++++++++++++++++++-------
 drivers/xen/swiotlb-xen.c           | 22 ++++++++-
 drivers/xen/xen-selfballoon.c       | 22 +++++++++
 include/xen/grant_table.h           | 10 ++--
 11 files changed, 197 insertions(+), 83 deletions(-)


Bob Liu (1):
      drivers: xen: deaggressive selfballoon driver

Dave Jones (1):
      xen/pvh: Fix misplaced kfree from xlated_setup_gnttab_pages

Ian Campbell (1):
      xen: swiotlb: handle sizeof(dma_addr_t) != sizeof(phys_addr_t)

Julien Grall (2):
      arm/xen: Initialize event channels earlier
      xen/gnttab: Use phys_addr_t to describe the grant frame base address

Zoltan Kiss (1):
      xen/grant-table: Avoid m2p_override during mapping

