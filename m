Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966655Ab3HHVIC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 17:08:02 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:46271 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966542Ab3HHVH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 17:07:59 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Arnd Bergmann <arnd@arndb.de>, Roland McGrath <roland@redhat.com>,
        Oleg Nesterov <oleg@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>
Subject: [PATCH 0/4] asm-generic: fix minor include guard issues
Date: Thu,  8 Aug 2013 21:06:58 +0000
Message-Id: <1375996022-8298-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I wrote a script to help find (potential) problems with include
guards, such as the same macro being used in different header
files. These patches are the result of applying that to
include/asm-generic. They are mostly trivial, but [1/4] fixes two
almost-problems.

I didn't touch include/asm-generic/rwsem.h, although it might need
some attention. It was introduced in dd472da38, seemingly a copy of
arch/powerpc/include/asm/rwsem.h, which was removed in 0766387bc. It
is not #included from anywhere, but is used in
arch/{hexagon,powerpc}/include/asm/Kbuild. Since it is no longer
powerpc-specific, the _ASM_POWERPC_RWSEM_H and #ifdef CONFIG_PPC64
seem malplaced.


Rasmus Villemoes (4):
  asm-generic: Make sure include guards contain the substring
    ASM_GENERIC
  asm-generic: Use different include guards
  asm-generic: Add missing include guards
  asm-generic: Fix typo in comment after #endif

 include/asm-generic/bitops/arch_hweight.h   |    2 +-
 include/asm-generic/bitops/atomic.h         |    2 +-
 include/asm-generic/cacheflush.h            |    6 +++---
 include/asm-generic/clkdev.h                |    4 ++--
 include/asm-generic/dma-coherent.h          |    4 ++--
 include/asm-generic/dma-contiguous.h        |    4 ++--
 include/asm-generic/dma-mapping-broken.h    |    6 +++---
 include/asm-generic/dma-mapping-common.h    |    4 ++--
 include/asm-generic/ide_iops.h              |    4 ++++
 include/asm-generic/io-64-nonatomic-hi-lo.h |    6 +++---
 include/asm-generic/io-64-nonatomic-lo-hi.h |    6 +++---
 include/asm-generic/iomap.h                 |    4 ++--
 include/asm-generic/memory_model.h          |    4 ++--
 include/asm-generic/pci_iomap.h             |    2 +-
 include/asm-generic/rtc.h                   |    6 +++---
 include/asm-generic/signal.h                |    2 +-
 include/asm-generic/statfs.h                |    4 ++--
 include/asm-generic/syscall.h               |    6 +++---
 include/asm-generic/unistd.h                |    5 +++++
 include/asm-generic/vga.h                   |    2 +-
 include/asm-generic/word-at-a-time.h        |    6 +++---
 include/asm-generic/xor.h                   |    4 ++++
 22 files changed, 53 insertions(+), 40 deletions(-)

-- 
1.7.9.5

