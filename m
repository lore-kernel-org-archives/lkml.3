Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab3LRQyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:54:08 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:19020 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752031Ab3LRQyG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:54:06 -0500
Date: Wed, 18 Dec 2013 11:53:56 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: xen-devel@lists.xensource.com, boris.ostrovsky@oracle.com,
        david.vrabel@citrix.com
Subject: [GIT PULL] (xen) stable/for-linus-3.14-rc4-tag
Message-ID: <20131218165356.GA4630@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey Linus,

Please git pull the following tag:

 git://git.kernel.org/pub/scm/linux/kernel/git/xen/tip.git stable/for-linus-3.13-rc4-tag

which has mostly ARM/ARM64 and some PVHVM fixes. This pull touches the generic 
drivers and also the arm sub-tree. The biggest change is in the
balloon driver - and that fix solves a bug with ARM64 (not working) and PVHVM
(working, but needlessly using extra memory). The details are as always
in the signed tag.

Please pull!


Eric Trudeau (1):
      XEN: Grant table address, xen_hvm_resume_frames, is a phys_addr not a pfn

Ian Campbell (2):
      xen: privcmd: do not return pages which we have failed to unmap
      arm: xen: foreign mapping PTEs are special.

Julien Grall (1):
      xen/block: Correctly define structures in public headers on ARM32 and ARM64

Stefano Stabellini (2):
      xen/arm64: do not call the swiotlb functions twice
      xen/balloon: Seperate the auto-translate logic properly (v2)


 arch/arm/xen/enlighten.c                   |  6 +--
 arch/arm64/include/asm/xen/page-coherent.h |  4 --
 drivers/xen/balloon.c                      | 63 ++++++++++++++++--------------
 drivers/xen/grant-table.c                  |  3 +-
 drivers/xen/privcmd.c                      |  9 ++++-
 include/xen/interface/io/blkif.h           | 10 ++---
 6 files changed, 51 insertions(+), 44 deletions(-)
