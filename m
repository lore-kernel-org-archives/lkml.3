Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934816Ab3BNUOt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 15:14:49 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59995 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758688Ab3BNUOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 15:14:48 -0500
Date: Thu, 14 Feb 2013 15:14:45 -0500 (EST)
Message-Id: <20130214.151445.2165581579573329189.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A couple small fixes for sparc including some THP brown-paper-bag
material:

1) During the merging of all the THP support for various architectures,
   sparc missed adding a HAVE_ARCH_TRANSPARENT_HUGEPAGE to it's Kconfig,
   oops.

2) Sparc needs to be mindful of hugepages in get_user_pages_fast().

3) Fix memory leak in SBUS probe, from Cong Ding.

4) The sunvdc virtual disk client driver has a test of the bitmask of
   vdisk server supported operations which was off by one bit.

Please pull, thanks a lot!

The following changes since commit 9a9284153d965a57edc7162a8e57c14c97f3a935:

  Merge branch 'drm-fixes' of git://people.freedesktop.org/~airlied/linux (2013-01-20 20:55:49 -0800)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc.git master

for you to fetch changes up to f4d9605434c0fd4cc8639bf25cfc043418c52362:

  sunvdc: Fix off-by-one in generic_request(). (2013-02-14 11:49:01 -0800)

----------------------------------------------------------------
Cong Ding (1):
      sparc: kernel/sbus.c: fix memory leakage

David S. Miller (3):
      sparc64: Add missing HAVE_ARCH_TRANSPARENT_HUGEPAGE.
      sparc64: Fix get_user_pages_fast() wrt. THP.
      sunvdc: Fix off-by-one in generic_request().

 arch/sparc/Kconfig                  |  1 +
 arch/sparc/include/asm/pgtable_64.h | 14 ++++++--------
 arch/sparc/kernel/sbus.c            |  6 +++---
 arch/sparc/mm/gup.c                 | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/block/sunvdc.c              |  2 +-
 5 files changed, 68 insertions(+), 14 deletions(-)
