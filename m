Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864AbaGGKSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 06:18:17 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:29547 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751392AbaGGKSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 06:18:13 -0400
X-IronPort-AV: E=Sophos;i="5.00,848,1396972800"; 
   d="scan'208";a="32931972"
Message-ID: <53BA7124.5070200@cn.fujitsu.com>
Date: Mon, 7 Jul 2014 18:06:28 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jens <axboe@kernel.dk>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Kent <kmo@daterainc.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] bio-integrity: remove the needless fail handle of bip_slab
 creating
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

bip_slab is created with SLAB_PANIC, so the fail handle is needless,
remove it.

Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
---
 block/bio-integrity.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 9e24106..56754c4 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -652,6 +652,4 @@ void __init bio_integrity_init(void)
 				     sizeof(struct bio_integrity_payload) +
 				     sizeof(struct bio_vec) * BIP_INLINE_VECS,
 				     0, SLAB_HWCACHE_ALIGN|SLAB_PANIC, NULL);
-	if (!bip_slab)
-		panic("Failed to create slab\n");
 }
-- 
1.7.7

