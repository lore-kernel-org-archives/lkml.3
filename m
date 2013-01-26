Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751210Ab3AZFwA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 00:52:00 -0500
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:55344 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab3AZFv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 00:51:59 -0500
X-AuditID: 9c930197-b7ca4ae000006ba8-af-51036efcac3b
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Michal Marek <mmarek@suse.cz>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, x86@kernel.org
Cc: Nitin Gupta <nitingupta910@gmail.com>,
        Richard Purdie <rpurdie@openedhand.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Albin Tonnerre <albin.tonnerre@free-electrons.com>, hyojun.im@lge.com,
        chan.jeong@lge.com, gunho.lee@lge.com, minchan.kim@lge.com,
        namhyung.kim@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>
Subject: =?UTF-8?q?=5BRFC=20PATCH=200/4=5D=20Add=20support=20for=20LZ4-compressed=20kernels?=
Date: Sat, 26 Jan 2013 14:50:43 +0900
Message-Id: <1359179447-31118-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.0.3
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is for supporting LZ4 compressed kernel and initial ramdisk on
the x86 and ARM architectures.

According to http://code.google.com/p/lz4/, LZ4 is a very fast lossless
compression algorithm and also features an extremely fast decoder.

Kernel Decompression APIs are based on implementation by Yann Collet
(http://code.google.com/p/lz4/source/checkout).
De/compression Tools are also provided from the site above.

The initial test result on ARM(v7) based board shows that the size of kernel
with LZ4 compressed is 8% bigger than LZO compressed  but the decompressing
speed is faster(especially under the enabled unaligned memory access).

Test: 3.4 based kernel built with many modules
Uncompressed kernel size: 13MB
lzo: 6.3MB, 301ms
lz4: 6.8MB, 251ms(167ms, with enabled unaligned memory access)

It seems that it’s worth trying LZ4 compressed kernel image or ramdisk 
for making the kernel boot more faster.

Thanks,
Kyungsik


Kyungsik Lee (4):
  decompressors: add lz4 decompressor module
  lib: add support for LZ4-compressed kernels
  arm: add support for LZ4-compressed kernels
  x86: add support for LZ4-compressed kernels

 arch/arm/Kconfig                      |   1 +
 arch/arm/boot/compressed/.gitignore   |   1 +
 arch/arm/boot/compressed/Makefile     |   3 +-
 arch/arm/boot/compressed/decompress.c |   4 +
 arch/arm/boot/compressed/piggy.lz4.S  |   6 +
 arch/x86/Kconfig                      |   1 +
 arch/x86/boot/compressed/Makefile     |   5 +-
 arch/x86/boot/compressed/misc.c       |   4 +
 include/linux/decompress/unlz4.h      |  10 ++
 include/linux/lz4.h                   |  62 +++++++++++
 init/Kconfig                          |  13 ++-
 lib/Kconfig                           |   7 ++
 lib/Makefile                          |   2 +
 lib/decompress.c                      |   5 +
 lib/decompress_unlz4.c                | 199 ++++++++++++++++++++++++++++++++++
 lib/lz4/Makefile                      |   1 +
 lib/lz4/lz4_decompress.c              | 199 ++++++++++++++++++++++++++++++++++
 lib/lz4/lz4defs.h                     | 129 ++++++++++++++++++++++
 scripts/Makefile.lib                  |   5 +
 usr/Kconfig                           |   9 ++
 20 files changed, 663 insertions(+), 3 deletions(-)
 create mode 100644 arch/arm/boot/compressed/piggy.lz4.S
 create mode 100644 include/linux/decompress/unlz4.h
 create mode 100644 include/linux/lz4.h
 create mode 100644 lib/decompress_unlz4.c
 create mode 100644 lib/lz4/Makefile
 create mode 100644 lib/lz4/lz4_decompress.c
 create mode 100644 lib/lz4/lz4defs.h

-- 
1.8.0.3

