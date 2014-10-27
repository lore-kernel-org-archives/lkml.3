Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaJ0Owj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 10:52:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53777 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951AbaJ0Owh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 10:52:37 -0400
From: Juergen Gross <jgross@suse.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        konrad.wilk@oracle.com, david.vrabel@citrix.com,
        boris.ostrovsky@oracle.com
Cc: Juergen Gross <jgross@suse.com>
Subject: [PATCH 0/2] xen: Switch to virtual mapped linear p2m list
Date: Mon, 27 Oct 2014 15:52:29 +0100
Message-Id: <1414421551-31555-1-git-send-email-jgross@suse.com>
X-Mailer: git-send-email 1.8.4.5
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

The first patch in this series modifies xen specific kernel
initialization to be able to switch to the linear mapped p2m list
introduced in the sewcond patch.

Juergen Gross (2):
  Xen: Delay remapping memory of pv-domain
  Xen: switch to linear virtual mapped sparse p2m list

 arch/x86/include/asm/pgtable_types.h |   1 +
 arch/x86/include/asm/xen/page.h      |  31 +-
 arch/x86/mm/pageattr.c               |  20 +
 arch/x86/xen/mmu.c                   |  38 +-
 arch/x86/xen/p2m.c                   | 986 +++++++++++++----------------------
 arch/x86/xen/setup.c                 | 455 ++++++++--------
 arch/x86/xen/xen-ops.h               |   6 +-
 7 files changed, 675 insertions(+), 862 deletions(-)

-- 
1.8.4.5

