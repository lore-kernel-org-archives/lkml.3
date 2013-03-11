Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3CKLCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 07:02:55 -0400
Received: from mail1.windriver.com ([147.11.146.13]:54835 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3CKLCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 07:02:53 -0400
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <jason.wessel@windriver.com>, <linuxppc-dev@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>
Subject: [v4][PATCH 0/7] powerpc/book3e: powerpc/book3e: make kgdb to work well
Date: Mon, 11 Mar 2013 19:02:39 +0800
Message-ID: <1362999766-20897-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is used to support kgdb/gdb on book3e.

Validated on p4080ds and p5040ds with test single step and breakpoint

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
Tiejun Chen (7):
      powerpc/book3e: load critical/machine/debug exception stack
      powerpc/book3e: store critical/machine/debug exception thread info
      book3e/kgdb: update thread's dbcr0
      powerpc/book3e: support kgdb for kernel space
      kgdb/kgdbts: support ppc64
      powerpc/kgdb: use DEFINE_PER_CPU to allocate kgdb's thread_info
      book3e/kgdb: Fix a single stgep case of lazy IRQ

 arch/powerpc/kernel/exceptions-64e.S |   68 ++++++++++++++++++++++++++++++++--
 arch/powerpc/kernel/irq.c            |   10 +++++
 arch/powerpc/kernel/kgdb.c           |   21 +++++++----
 drivers/misc/kgdbts.c                |    2 +
 4 files changed, 90 insertions(+), 11 deletions(-)

Tiejun
