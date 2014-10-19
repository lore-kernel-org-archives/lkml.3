Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaJSR1C (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Oct 2014 13:27:02 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55001 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077AbaJSR1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Oct 2014 13:27:00 -0400
Date: Sun, 19 Oct 2014 13:26:58 -0400 (EDT)
Message-Id: <20141019.132658.178402001080955021.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Oct 2014 10:26:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Here we have two bug fixes:

1) The current thread's fault_code is not setup properly upon entry to
   do_sparc64_fault() in some paths, leading to spurious SIGBUS.

2) Don't use a zero length array at the end of thread_info on sparc64,
   otherwise end_of_stack() isn't right.

Please pull, thanks!

The following changes since commit 52d589a01d4545ce1dc5c3892bb8c7b55edfe714:

  Merge branch 'for-linus' of git://git.infradead.org/users/vkoul/slave-dma (2014-10-18 18:11:04 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to e2653143d7d79a49f1a961aeae1d82612838b12c:

  sparc64: Do not define thread fpregs save area as zero-length array. (2014-10-18 23:12:33 -0400)

----------------------------------------------------------------
David S. Miller (2):
      sparc64: Fix corrupted thread fault code.
      sparc64: Do not define thread fpregs save area as zero-length array.

 arch/sparc/include/asm/thread_info_64.h | 3 ++-
 arch/sparc/kernel/dtlb_prot.S           | 6 +++---
 arch/sparc/kernel/tsb.S                 | 6 +++---
 3 files changed, 8 insertions(+), 7 deletions(-)
