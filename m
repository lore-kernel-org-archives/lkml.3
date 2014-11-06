Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751433AbaKFFrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:47:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39690 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751121AbaKFFrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:47:40 -0500
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com, x86@kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH V2 0/5] xen: Switch to virtual mapped linear p2m list
Date: Thu,  6 Nov 2014 06:47:28 +0100
Message-Id: <1415252853-7106-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paravirtualized kernels running on Xen use a three level tree for
translation of guest specific physical addresses to machine global
addresses. This p2m tree is used for construction of page table
entries, so the p2m tree walk is performance critical.

By using a linear virtual mapped p2m list accesses to p2m elements
can be sped up while even simplifying code. To achieve this goal
some p2m related initializations have to be performed later in the
boot process, as the final p2m list can be set up only after basic
memory management functions are available.

Changes in V2:
- splitted patch 2 in 4 smaller ones as requested by David Vrabel
- added highmem check when remapping kernel memory as requested by
  David Vrabel

Juergen Gross (5):
  Xen: Delay remapping memory of pv-domain
  xen: Delay m2p_override initialization
  xen: Delay invalidating extra memory
  x86: Introduce function to get pmd entry pointer
  Xen: switch to linear virtual mapped sparse p2m list

 arch/x86/include/asm/pgtable_types.h |    1 +
 arch/x86/include/asm/xen/page.h      |   37 +-
 arch/x86/mm/pageattr.c               |   20 +
 arch/x86/xen/mmu.c                   |   38 +-
 arch/x86/xen/p2m.c                   | 1149 +++++++++++++---------------------
 arch/x86/xen/setup.c                 |  460 +++++++-------
 arch/x86/xen/xen-ops.h               |    6 +-
 7 files changed, 760 insertions(+), 951 deletions(-)

-- 
2.1.2

