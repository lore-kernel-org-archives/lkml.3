Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756624Ab3CNJsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 05:48:24 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:41432 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab3CNJsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 05:48:21 -0400
MIME-Version: 1.0
Date: Thu, 14 Mar 2013 18:48:20 +0900
X-Google-Sender-Auth: 2HH5WwAoKqJAmYPPFnIcIi289cI
Message-ID: <CAOAMb1D+h8BRu=YWQ9dJ3JN-5CmmDLjgq1mLnnCH9TELrPx2bw@mail.gmail.com>
Subject: [PATCH 0/2] lib,crypto: Add lz4 compressor module and crypto API
From: Chanho Min <chanho.min@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Darrick J. Wong" <djwong@us.ibm.com>,
        Bob Pearson <rpearson@systemfabricworks.com>,
        Richard Weinberger <richard@nod.at>,
        Herbert Xu <herbert@gondor.hengli.com.au>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Yann Collet <yann.collet.73@gmail.com>,
        Kyungsik Lee <kyungsik.lee@lge.com>, Chanho Min <chanho0207@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is for supporting LZ4 compression and the crypto API using it.
This should be applied after the previous Kyungsik's "LZ4 compressed kernel"
patches - https://lkml.org/lkml/2013/3/5/181.

As shown in bellow result, the size of data is a little bit bigger but
compressing speed is faster under the enabled unaligned memory access.
We can use lz4 de/compression through crypto API as well. Also,
It will be useful for another potential user of lz4 compression.

lz4 Compression Benchmark:
Compiler: ARM gcc 4.6.4
ARMv7, 1 GHz based board
   Kernel: linux 3.4
   Uncompressed data Size: 101 MB
         Compressed Size  compression Speed
   LZO   72.1MB		  32.1MB/s, 33.0MB/s(UA)
   LZ4   75.1MB		  30.4MB/s, 35.9MB/s(UA)
   LZ4HC 59.8MB		   2.4MB/s,  2.5MB/s(UA)
- UA: Unaligned memory Access support
- Latest patch set for LZO applied

Chanho Min (2):
  lib: Add lz4 compressor module
  crypto: Add lz4 Cryptographic API

 crypto/Kconfig           |   16 ++
 crypto/Makefile          |    2 +
 crypto/lz4.c             |  105 +++++++++
 crypto/lz4hc.c           |  105 +++++++++
 include/linux/lz4.h      |   36 ++++
 lib/Kconfig              |    6 +
 lib/Makefile             |    2 +
 lib/lz4/Makefile         |    2 +
 lib/lz4/lz4_compress.c   |  443 +++++++++++++++++++++++++++++++++++++
 lib/lz4/lz4defs.h        |   66 +++++-
 lib/lz4/lz4hc_compress.c |  539 ++++++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 1320 insertions(+), 2 deletions(-)
 create mode 100644 crypto/lz4.c
 create mode 100644 crypto/lz4hc.c
 create mode 100644 lib/lz4/lz4_compress.c
 create mode 100644 lib/lz4/lz4hc_compress.c

-- 
1.7.9.5
