Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab3AUHo3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 02:44:29 -0500
Received: from mail1.windriver.com ([147.11.146.13]:56177 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab3AUHo2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 02:44:28 -0500
From: Tiejun Chen <tiejun.chen@windriver.com>
To: <benh@kernel.crashing.org>, <galak@kernel.crashing.org>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <jason.wessel@windriver.com>
Subject: [v2][PATCH 0/6] powerpc/book3e: make kgdb to work well
Date: Mon, 21 Jan 2013 15:44:09 +0800
Message-ID: <1358754255-31484-1-git-send-email-tiejun.chen@windriver.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is used to support kgdb/gdb on book3e.

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


Tiejun Chen (6):
      powerpc/book3e: load critical/machine/debug exception stack
      powerpc/book3e: store critical/machine/debug exception thread info
      book3e/kgdb: update thread's dbcr0
      book3e/kgdb: Fix a single stgep case of lazy IRQ
      powerpc/book3e: support kgdb for kernel space
      kgdb/kgdbts: support ppc64

 arch/powerpc/kernel/exceptions-64e.S |   60 +++++++++++++++++++++++++++++++---
 arch/powerpc/kernel/irq.c            |   10 ++++++
 arch/powerpc/kernel/kgdb.c           |   16 ++++++---
 drivers/misc/kgdbts.c                |    2 ++
 4 files changed, 80 insertions(+), 8 deletions(-)

Tiejun
