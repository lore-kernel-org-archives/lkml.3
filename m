Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752718AbbAOI63 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2015 03:58:29 -0500
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:44470 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382AbbAOI6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2015 03:58:18 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, kvm@vger.kernel.org, kvm-ppc@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, x86@kernel.org,
        xen-devel@lists.xenproject.org, linux-mm@kvack.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: [PATCH 0/8] current ACCESS_ONCE patch queue
Date: Thu, 15 Jan 2015 09:58:26 +0100
Message-Id: <1421312314-72330-1-git-send-email-borntraeger@de.ibm.com>
X-Mailer: git-send-email 1.9.3
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15011508-0017-0000-0000-000002A59E16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

fyi, this is my current patch queue for the next merge window. It
does contain a patch that will disallow ACCESS_ONCE on non-scalar
types.

The tree is part of linux-next and can be found at
git://git.kernel.org/pub/scm/linux/kernel/git/borntraeger/linux.git linux-next


Christian Borntraeger (7):
  ppc/kvm: Replace ACCESS_ONCE with READ_ONCE
  ppc/hugetlbfs: Replace ACCESS_ONCE with READ_ONCE
  x86/xen/p2m: Replace ACCESS_ONCE with READ_ONCE
  x86/spinlock: Leftover conversion ACCESS_ONCE->READ_ONCE
  mm/gup: Replace ACCESS_ONCE with READ_ONCE
  kernel: tighten rules for ACCESS ONCE
  kernel: Fix sparse warning for ACCESS_ONCE

Guenter Roeck (1):
  next: sh: Fix compile error

 arch/powerpc/kvm/book3s_hv_rm_xics.c |  8 ++++----
 arch/powerpc/kvm/book3s_xics.c       | 16 ++++++++--------
 arch/powerpc/mm/hugetlbpage.c        |  4 ++--
 arch/sh/mm/gup.c                     |  2 +-
 arch/x86/include/asm/spinlock.h      |  2 +-
 arch/x86/xen/p2m.c                   |  2 +-
 include/linux/compiler.h             | 21 ++++++++++++++++-----
 mm/gup.c                             |  2 +-
 8 files changed, 34 insertions(+), 23 deletions(-)

-- 
1.9.3

