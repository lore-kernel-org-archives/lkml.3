Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711AbaE3Fjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 01:39:43 -0400
Received: from ns.horizon.com ([71.41.210.147]:37996 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751926AbaE3Fjm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 01:39:42 -0400
Date: 30 May 2014 01:39:41 -0400
Message-ID: <20140530053941.20986.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: davem@davemloft.net, dborkman@redhat.com
Subject: [PATCH 2/3] lib: crc32: mark test data __initconst
Cc: linux-kernel@vger.kernel.org, linux@horizon.com
In-Reply-To: <20140530053505.18155.qmail@ns.horizon.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 1ecab5281e3cfc8c2a61648410c8b25ba2654fcb Mon Sep 17 00:00:00 2001
From: George Spelvin <linux@horizon.com>
Date: Thu, 29 May 2014 00:08:03 -0400
Subject: [PATCH 2/3] lib: crc32: mark test data __initconst

So it gets discarded after the selftest.

Signed-off-by: George Spelvin <linux@horizon.com>
---
This is the patch I started with, when I was looking for lib/ self-test
code to emulate for my still-pending glob.c code.  But curiosity about
the combine code led me notice problems with it, and to study the
arch/x86/crypto code, where I also have a proposed patch.

Aren't tangents fun?

 lib/crc32.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index a4a576f3..977167d6 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -341,7 +341,7 @@ EXPORT_SYMBOL(crc32_be);
 #ifdef CONFIG_CRC32_SELFTEST
 
 /* 4096 random bytes */
-static u8 __attribute__((__aligned__(8))) test_buf[] =
+static u8 const __aligned(8) test_buf[] __initconst =
 {
 	0x5b, 0x85, 0x21, 0xcb, 0x09, 0x68, 0x7d, 0x30,
 	0xc7, 0x69, 0xd7, 0x30, 0x92, 0xde, 0x59, 0xe4,
@@ -865,7 +865,7 @@ static struct crc_test {
 	u32 crc_le;	/* expected crc32_le result */
 	u32 crc_be;	/* expected crc32_be result */
 	u32 crc32c_le;	/* expected crc32c_le result */
-} test[] =
+} const test[] __initconst =
 {
 	{0x674bf11d, 0x00000038, 0x00000542, 0x0af6d466, 0xd8b6e4c1, 0xf6e93d6c},
 	{0x35c672c6, 0x0000003a, 0x000001aa, 0xc6d3dfba, 0x28aaf3ad, 0x0fe92aca},
-- 
1.9.2

