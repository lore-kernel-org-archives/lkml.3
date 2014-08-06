Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754058AbaHFFDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 01:03:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36061 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323AbaHFFDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 01:03:09 -0400
Date: Tue, 05 Aug 2014 22:03:08 -0700 (PDT)
Message-Id: <20140805.220308.143651566778367079.davem@davemloft.net>
To: torvalds@linux-foundation.org
CC: akpm@linux-foundation.org, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [GIT] Sparc
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 Aug 2014 22:03:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


1) Add sparc RAM output to /proc/iomem, from Bob Picco.

2) Allow seeks on /dev/mdesc, from Khalid Aziz.

3) Cleanup sparc64 I/O accessors, from Sam Ravnborg.

4) If update_mmu_cache{,_pmd}() is called with an not-valid mapping,
   do not insert it into the TLB miss hash tables otherwise we'll
   livelock.  Based upon work by Christopher Alexander Tobias Schulze.

5) Fix BREAK detection in sunsab driver when no actual characters
   are pending, from Christopher Alexander Tobias Schulze.

6) Because we have modules --> openfirmware --> vmalloc ordering of
   virtual memory, the lazy VMAP TLB flusher can cons up an invocation
   of flush_tlb_kernel_range() that covers the openfirmware address
   range.  Unfortunately this will flush out the firmware's locked
   TLB mapping which causes all kinds of trouble.  Just split up
   the flush request if this happens, but in the long term the lazy
   VMAP flusher should probably be made a little bit smarter.

   Based upon work by Christopher Alexander Tobias Schulze.

Please pull, thanks a lot!

The following changes since commit 31dab719fa50cf56d56d3dc25980fecd336f6ca8:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/herbert/crypto-2.6 (2014-07-28 11:35:30 -0700)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/davem/sparc-next.git master

for you to fetch changes up to 5b6ff9df056b69a3b65708bfb9923af41146c8c8:

  sparc64: Fix up merge thinko. (2014-08-05 19:09:19 -0700)

----------------------------------------------------------------
Andrey Utkin (1):
      arch/sparc/math-emu/math_32.c: drop stray break operator

Christopher Alexander Tobias Schulze (2):
      bbc-i2c: Fix BBC I2C envctrl on SunBlade 2000
      sunsab: Fix detection of BREAK on sunsab serial console

David L Stevens (1):
      sparc: Add "install" target

David S. Miller (5):
      Merge branch 'sparc64_io'
      sparc64: Do not insert non-valid PTEs into the TSB hash table.
      sparc64: Guard against flushing openfirmware mappings.
      Merge git://git.kernel.org/.../davem/sparc
      sparc64: Fix up merge thinko.

Himangi Saraogi (1):
      display7seg: Introduce the use of the managed version of kzalloc

Kees Cook (1):
      sparc: use %s for unaligned panic

Khalid Aziz (1):
      sparc: Add support for seek and shorter read to /dev/mdesc

Rasmus Villemoes (1):
      drivers/sbus/char: Micro-optimization in display7seg.c

Sam Ravnborg (6):
      sparcspkr: use sbus_*() primitives for IO
      sparc64: update IO access functions in PeeCeeI
      sparc64: remove macro indirection in io_64.h
      sparc64: drop unused SLOW_DOWN_IO definitions
      sparc64: reorder functions in io_64.h
      sparc64: avoid code duplication in io_64.h

Sowmini Varadhan (1):
      sparc64: ldc_connect() should not return EINVAL when handshake is in progress.

bob picco (1):
      sparc64 - add mem to iomem resource

 arch/sparc/Makefile                  |   3 +
 arch/sparc/boot/Makefile             |   4 +
 arch/sparc/boot/install.sh           |  50 ++++++++++
 arch/sparc/include/asm/io_64.h       | 381 ++++++++++++++++++++++++++++---------------------------------------------
 arch/sparc/include/asm/tlbflush_64.h |  12 +--
 arch/sparc/kernel/ldc.c              |   2 +-
 arch/sparc/kernel/mdesc.c            |  82 +++++++++++++---
 arch/sparc/kernel/unaligned_32.c     |   2 +-
 arch/sparc/lib/PeeCeeI.c             |  36 +++----
 arch/sparc/math-emu/math_32.c        |   2 +-
 arch/sparc/mm/init_64.c              |  96 +++++++++++++++++++
 drivers/input/misc/sparcspkr.c       |  22 ++---
 drivers/sbus/char/bbc_envctrl.c      |   6 ++
 drivers/sbus/char/bbc_i2c.c          |  11 ++-
 drivers/sbus/char/display7seg.c      |  10 +-
 drivers/tty/serial/sunsab.c          |   9 ++
 16 files changed, 427 insertions(+), 301 deletions(-)
 create mode 100644 arch/sparc/boot/install.sh
