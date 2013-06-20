Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab3FTK2t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 06:28:49 -0400
Received: from mail.windriver.com ([147.11.1.11]:60775 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754512Ab3FTK2s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 06:28:48 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>
CC: <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: [v5][PATCH 0/6] powerpc/book3e: powerpc/book3e: make kgdb to work well
Date: Thu, 20 Jun 2013 18:28:24 +0800
Message-ID: <1371724110-8250-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben,

As you mention just now, I resend this another pending patch sets v5 used
to support kgdb/gdb on book3e.

v5:

* rebase on merge branch.

Note the original patch, [ATCH 5/7] kgdb/kgdbts: support ppc64, is already merged
by Jason.

v4:

* use DEFINE_PER_CPU to allocate kgdb's thread_info
* add patch 7 to make usre copy thread_info only !__check_irq_replay
* leave "andi.   r14,r11,MSR_PR" out of "#ifndef CONFIG_KGDB"
  since cr0 is still used lately.
* retest

v3:

* make work when enable CONFIG_RELOCATABLE
* fix one typo in patch,
  "powerpc/book3e: store critical/machine/debug exception thread info": 
	ld	r1,PACAKSAVE(r13);
    ->  ld	r14,PACAKSAVE(r13);
* remove copying the thread_info since booke and book3e always copy
  the thead_info now when we enter the debug exception, and so drop
  the v2 patch, "book3e/kgdb: Fix a single stgep case of lazy IRQ"

v2:

* Make sure we cover CONFIG_PPC_BOOK3E_64 safely
* Use LOAD_REG_IMMEDIATE() to load properly
	the value of the constant expression in load debug exception stack 
* Copy thread infor form the kernel stack coming from usr
* Rebase latest powerpc git tree

v1:
* Copy thread info only when we are from !user mode since we'll get kernel stack
  coming from usr directly.
* remove save/restore EX_R14/EX_R15 since DBG_EXCEPTION_PROLOG already covered
  this.
* use CURRENT_THREAD_INFO() conveniently to get thread.
* fix some typos
* add a patch to make sure gdb can generate a single step properly to invoke a
  kgdb state.
* add a patch to if we need to replay an interrupt, we shouldn't restore that
  previous backup thread info to make sure we can replay an interrupt lately
  with a proper thread info.
* rebase latest powerpc git tree

v0:
This patchset is used to support kgdb for book3e.

------
Tiejun Chen (6):
      powerpc/book3e: load critical/machine/debug exception stack
      powerpc/book3e: store critical/machine/debug exception thread info
      book3e/kgdb: update thread's dbcr0
      powerpc/book3e: support kgdb for kernel space
      powerpc/kgdb: use DEFINE_PER_CPU to allocate kgdb's thread_info
      book3e/kgdb: Fix a single stgep case of lazy IRQ

 arch/powerpc/kernel/exceptions-64e.S |   68 ++++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/irq.c            |   10 +++++
 arch/powerpc/kernel/kgdb.c           |   21 +++++++----
 3 files changed, 88 insertions(+), 11 deletions(-)

Tiejun
