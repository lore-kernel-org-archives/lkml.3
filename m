Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757671AbaEFPaf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 11:30:35 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40806 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121AbaEFPad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 11:30:33 -0400
Date: Tue, 06 May 2014 11:30:31 -0400 (EDT)
Message-Id: <20140506.113031.1577209312429629073.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 May 2014 08:30:33 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I've been auditing the THP support on sparc64 and found several bugs,
hopefully most of which are fixed completely here.

Also an RT kernel locking fix from Kirill Tkhai.

Please pull, thanks a lot!

The following changes since commit b7270cce7db770602510043b212992d839fd25a6:

  Merge tag 'rdma-for-linus' of git://git.kernel.org/pub/scm/linux/kernel/git/roland/infiniband (2014-05-01 17:52:42 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to fe866433f843b080246ce729b5e6b27b5f5d9a58:

  sparc64: Give more detailed information in {pgd,pmd}_ERROR() and kill pte_ERROR(). (2014-05-03 22:56:25 -0700)

----------------------------------------------------------------
David S. Miller (13):
      sparc64: Fix argument sign extension for compat_sys_futex().
      sparc64: Normalize NMI watchdog logging and behavior.
      sparc64: Fix executable bit testing in set_pmd_at() paths.
      sparc64: Fix huge PMD invalidation.
      sparc64: Fix bugs in get_user_pages_fast() wrt. THP.
      sparc64: Fix hex values in comment above pte_modify().
      sparc64: Don't use _PAGE_PRESENT in pte_modify() mask.
      sparc64: Handle 32-bit tasks properly in compute_effective_address().
      sparc64: Fix top-level fault handling bugs.
      sparc64: Fix range check in kern_addr_valid().
      sparc64: Use 'ILOG2_4MB' instead of constant '22'.
      sparc64: Add basic validations to {pud,pmd}_bad().
      sparc64: Give more detailed information in {pgd,pmd}_ERROR() and kill pte_ERROR().

Kirill Tkhai (1):
      sparc64: Make itc_sync_lock raw

 arch/sparc/include/asm/pgtable_64.h | 83 ++++++++++++++++++++++++++++++++++++++------------------------------
 arch/sparc/include/asm/tsb.h        |  3 ++-
 arch/sparc/kernel/head_64.S         |  4 ++--
 arch/sparc/kernel/ktlb.S            |  2 +-
 arch/sparc/kernel/nmi.c             | 21 +++++------------
 arch/sparc/kernel/smp_64.c          |  6 ++---
 arch/sparc/kernel/sys32.S           |  2 +-
 arch/sparc/kernel/unaligned_64.c    | 12 +++++++---
 arch/sparc/mm/fault_64.c            | 82 ++++++++++++++++++++++++++++++++++++++++++-------------------------
 arch/sparc/mm/gup.c                 |  2 +-
 arch/sparc/mm/init_64.c             | 12 +++++-----
 arch/sparc/mm/tlb.c                 | 26 ++++++++++++++++-----
 12 files changed, 148 insertions(+), 107 deletions(-)
