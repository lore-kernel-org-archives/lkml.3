Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752691AbaILTn6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 15:43:58 -0400
Received: from smtp.citrix.com ([66.165.176.89]:65209 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751208AbaILTnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 15:43:55 -0400
X-IronPort-AV: E=Sophos;i="5.04,514,1406592000"; 
   d="scan'208";a="171079241"
Date: Fri, 12 Sep 2014 20:41:05 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: <torvalds@linux-foundation.org>
CC: <david.vrabel@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>
Subject: [GIT PULL] xen on arm bug fix for 3.17-rc4
Message-ID: <alpine.DEB.2.02.1409122017120.8137@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,
please pull the following tag:

git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.17-b-rc4-arm-tag

The patches fix the "xen_add_mach_to_phys_entry: cannot add" bug that
has been affecting xen on arm and arm64 guests since 3.16. They require
a few hypervisor side changes that just went in xen-unstable.

A couple of days ago David sent out a pull request with a few other Xen
fixes (it is already in master). Sorry we didn't synchronized better
among us.


Stefano Stabellini (3):
      xen/arm: introduce XENFEAT_grant_map_identity
      xen/arm: reimplement xen_dma_unmap_page & friends
      xen/arm: remove mach_to_phys rbtree

 arch/arm/include/asm/xen/page-coherent.h |   25 ++--
 arch/arm/include/asm/xen/page.h          |    9 --
 arch/arm/xen/Makefile                    |    2 +-
 arch/arm/xen/enlighten.c                 |    6 +
 arch/arm/xen/mm32.c                      |  202 ++++++++++++++++++++++++++++++
 arch/arm/xen/p2m.c                       |   66 +---------
 include/xen/interface/features.h         |    3 +
 7 files changed, 220 insertions(+), 93 deletions(-)
 create mode 100644 arch/arm/xen/mm32.c
