Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805Ab3CELr5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 06:47:57 -0500
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54257 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752351Ab3CELrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 06:47:55 -0500
X-AuditID: 9c93016f-b7b46ae000000e4b-30-5135db6930f3
From: Kyungsik Lee <kyungsik.lee@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org
Cc: Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com,
        Kyungsik Lee <kyungsik.lee@lge.com>
Subject: [PATCH v3 -next 0/5] Add support for LZ4-compressed kernel
Date: Tue,  5 Mar 2013 20:47:31 +0900
Message-Id: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com>
X-Mailer: git-send-email 1.8.1.1
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the third version. In this version, Some codes are fixed
and more description and note are added. I would like to thank David Sterba
for his review.

The Last patch[5/5] of the patch set is for making x86 and arm default to
LZ4-compressed for testing the LZ4 code in the linux-next.
It was requested by Andrew Morton in the patch set v2.

Currently, A preliminary version of LZ4 de/compression tool is supported.
However, It is expected that we will have a tool with more features
once its format is finished.

LZ4 compression tool is available at
http://code.google.com/p/lz4/source/checkout.

Thanks,
Kyungsik


Change log: v2
- Clean up code
- Enable unaligned access for ARM v6 and above with
  CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
- Add lz4_decompress() for faster decompression with
  uncompressed output size
- Use lz4_decompress() for LZ4-compressed kernel during
  boot-process
- Apply -Os to decompress.o to improve decompress
  performance during boot-up process
Change log: v3
- Prevent double evaluation by using an inline function
- Add LZ4 description and note for uncompressed chunk size issue
- Fix indentation error


Kyungsik Lee (5):
  decompressor: Add LZ4 decompressor module
  lib: Add support for LZ4-compressed kernel
  arm: Add support for LZ4-compressed kernel
  x86: Add support for LZ4-compressed kernel
  Kconfig: Make x86 and arm kernels default to the LZ4-compressed

 arch/arm/Kconfig                      |   1 +
 arch/arm/boot/compressed/.gitignore   |   1 +
 arch/arm/boot/compressed/Makefile     |   6 +-
 arch/arm/boot/compressed/decompress.c |   4 +
 arch/arm/boot/compressed/piggy.lz4.S  |   6 +
 arch/x86/Kconfig                      |   1 +
 arch/x86/boot/compressed/Makefile     |   5 +-
 arch/x86/boot/compressed/misc.c       |   4 +
 include/linux/decompress/unlz4.h      |  10 ++
 include/linux/lz4.h                   |  51 ++++++
 init/Kconfig                          |  19 +-
 lib/Kconfig                           |   7 +
 lib/Makefile                          |   2 +
 lib/decompress.c                      |   5 +
 lib/decompress_unlz4.c                | 187 +++++++++++++++++++
 lib/lz4/Makefile                      |   1 +
 lib/lz4/lz4_decompress.c              | 326 ++++++++++++++++++++++++++++++++++
 lib/lz4/lz4defs.h                     |  94 ++++++++++
 scripts/Makefile.lib                  |   5 +
 usr/Kconfig                           |   9 +
 20 files changed, 740 insertions(+), 4 deletions(-)
 create mode 100644 arch/arm/boot/compressed/piggy.lz4.S
 create mode 100644 include/linux/decompress/unlz4.h
 create mode 100644 include/linux/lz4.h
 create mode 100644 lib/decompress_unlz4.c
 create mode 100644 lib/lz4/Makefile
 create mode 100644 lib/lz4/lz4_decompress.c
 create mode 100644 lib/lz4/lz4defs.h

-- 
1.8.1.1

