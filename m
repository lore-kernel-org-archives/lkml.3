Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752766Ab3BTWJU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 17:09:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50778 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab3BTWJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 17:09:14 -0500
Date: Wed, 20 Feb 2013 17:09:12 -0500 (EST)
Message-Id: <20130220.170912.2195791275106336110.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Wed, 20 Feb 2013 14:09:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Mostly more sparc64 THP bug fixes, and a refactoring of SMP bootup on sparc32
from Sam Ravnborg.

Please pull, thanks a lot!

The following changes since commit f741656d646f7a5b56ba86765205b954237e7956:

  Merge tag 'stable/for-linus-3.8-rc7-tag-two' of git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen (2013-02-15 12:12:55 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to f9fd3488f6a3c2c5cc8613e4fd7fbbaa57f6bf8f:

  sparc32: refactor smp boot (2013-02-20 13:36:50 -0800)

----------------------------------------------------------------
David S. Miller (4):
      sparc64: Fix gfp_flags setting in tsb_grow().
      sparc64: Handle hugepage TSB being NULL.
      sparc64: Fix tsb_grow() in atomic context.
      sparc64: Fix huge PMD to PTE translation for sun4u in TLB miss handler.

Sam Ravnborg (1):
      sparc32: refactor smp boot

 arch/sparc/include/asm/hugetlb.h  |  1 -
 arch/sparc/include/asm/page_64.h  |  4 ++--
 arch/sparc/include/asm/tsb.h      | 28 +++++++++++++++++++---------
 arch/sparc/kernel/kernel.h        | 12 ++++++++++++
 arch/sparc/kernel/leon_smp.c      | 33 +++++++++------------------------
 arch/sparc/kernel/smp_32.c        | 86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 arch/sparc/kernel/sun4d_smp.c     | 29 +++++++++--------------------
 arch/sparc/kernel/sun4m_smp.c     | 33 +++++++++------------------------
 arch/sparc/kernel/trampoline_32.S | 17 +++++++----------
 arch/sparc/kernel/tsb.S           | 39 +++++++++++++++++++++++++++++++++++----
 arch/sparc/mm/fault_64.c          |  9 +++++++--
 arch/sparc/mm/init_64.c           | 62 +++++++++++++++++++++++++++++++++++++++++---------------------
 arch/sparc/mm/tlb.c               | 11 +++++++++--
 arch/sparc/mm/tsb.c               |  2 +-
 14 files changed, 246 insertions(+), 120 deletions(-)
