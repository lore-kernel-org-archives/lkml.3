Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751632Ab3BVF2g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 00:28:36 -0500
Received: from mail.servus.at ([193.170.194.20]:38929 "EHLO mail.servus.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750707Ab3BVF2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 00:28:35 -0500
Message-ID: <51270182.4080205@oberhumer.com>
Date: Fri, 22 Feb 2013 06:26:26 +0100
From: "Markus F.X.J. Oberhumer" <markus@oberhumer.com>
Organization: oberhumer.com
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] Update LZO compression code for v3.9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull my "lzo-update" branch from

  git://github.com/markus-oberhumer/linux.git lzo-update

You can also browse the branch at

  https://github.com/markus-oberhumer/linux/compare/lzo-update

The LZO update actually had been approved by akpm for a 3.7 merge and is
available in linux-next since October, but I've only recently learned
that there is no automatic flow from linux-next to linux and I have
to personally send a pull request.

Many thanks,
Markus


Summary:
========

Update the Linux kernel LZO compression and decompression code to the current
upstream version which features significant performance improvements
on modern machines.

$ git shortlog v3.8..lzo-update
Markus F.X.J. Oberhumer (3):
      lib/lzo: Rename lzo1x_decompress.c to lzo1x_decompress_safe.c
      lib/lzo: Update LZO compression to current upstream version
      crypto: testmgr - update LZO compression test vectors

$ git diff --stat v3.8..lzo-update
 crypto/testmgr.h                |   38 +++--
 include/linux/lzo.h             |   15 +-
 lib/decompress_unlzo.c          |    2 +-
 lib/lzo/Makefile                |    2 +-
 lib/lzo/lzo1x_compress.c        |  335 ++++++++++++++++++++++----------------
 lib/lzo/lzo1x_decompress.c      |  255 -----------------------------
 lib/lzo/lzo1x_decompress_safe.c |  237 +++++++++++++++++++++++++++
 lib/lzo/lzodefs.h               |   38 +++--
 8 files changed, 488 insertions(+), 434 deletions(-)


Some *synthetic* benchmarks:
============================

x86_64 (Sandy Bridge), gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2005    :         150 MB/sec          468 MB/sec
  LZO-2012    :         434 MB/sec         1210 MB/sec

i386 (Sandy Bridge), gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2005    :         143 MB/sec          409 MB/sec
  LZO-2012    :         372 MB/sec         1121 MB/sec

armv7 (Cortex-A9), Linaro gcc-4.6 -O3, Silesia test corpus, 256 kB block-size:

                   compression speed   decompression speed

  LZO-2005    :          27 MB/sec           84 MB/sec
  LZO-2012    :          44 MB/sec          117 MB/sec
**LZO-2013-UA :          47 MB/sec          167 MB/sec

Legend:

  LZO-2005    : LZO version in current 3.8 kernel (which is based on
                   the LZO 2.02 release from 2005)
  LZO-2012    : updated LZO version available in linux-next
**LZO-2013-UA : updated LZO version available in linux-next plus experimental
                   ARM Unaligned Access patch. This needs approval
                   from some ARM maintainer ist NOT YET INCLUDED.


-- 
Markus Oberhumer, <markus@oberhumer.com>, http://www.oberhumer.com/
