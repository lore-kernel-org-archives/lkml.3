Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757396AbaHZHcb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 03:32:31 -0400
Received: from mail.eperm.de ([89.247.134.16]:46908 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143AbaHZHc3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 03:32:29 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: kbuild test robot <fengguang.wu@intel.com>, kbuild-all@01.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] DRBG: fix sparse warning for cpu_to_be[32|64]
Date: Tue, 26 Aug 2014 09:32:24 +0200
Message-ID: <1803846.LZmvEct3qr@myon.chronox.de>
User-Agent: KMail/4.13.3 (Linux/3.15.10-200.fc20.x86_64; KDE/4.13.3; x86_64; ; )
In-Reply-To: <53fc2da5.AS8xtJ0DprRMVjVq%fengguang.wu@intel.com>
References: <53fc2da5.AS8xtJ0DprRMVjVq%fengguang.wu@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sparse tool complained that the cpu_to_be[32|64] functions return
__be[32|64] instead of __u32 or __u64. The patch replaces the __u32 and
__u64 with __be32 and __be64.

Reported-by: kbuild test robot <fengguang.wu@intel.com>
Signed-off-by: Stephan Mueller <smueller@chronox.de>
---
 crypto/drbg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/crypto/drbg.c b/crypto/drbg.c
index 9fd239f..39ed918 100644
--- a/crypto/drbg.c
+++ b/crypto/drbg.c
@@ -277,7 +277,7 @@ static bool drbg_fips_continuous_test(struct drbg_state *drbg,
 static inline void drbg_cpu_to_be32(__u32 val, unsigned char *buf)
 {
 	struct s {
-		__u32 conv;
+		__be32 conv;
 	};
 	struct s *conversion = (struct s *) buf;
 
@@ -989,7 +989,7 @@ static int drbg_hash_generate(struct drbg_state *drbg,
 	int ret = 0;
 	union {
 		unsigned char req[8];
-		__u64 req_int;
+		__be64 req_int;
 	} u;
 	unsigned char prefix = DRBG_PREFIX3;
 	struct drbg_string data1, data2;
-- 
1.9.3


