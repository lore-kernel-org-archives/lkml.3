Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473AbaJLCPO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 22:15:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:42001 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbaJLCPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 22:15:12 -0400
Date: Sat, 11 Oct 2014 22:15:10 -0400 (EDT)
Message-Id: <20141011.221510.1574777235900788349.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: cl@linux.com, penberg@kernel.org, rientjes@google.com,
        iamjoonsoo.kim@lge.com, akpm@linux-foundation.org, linux-mm@kvack.org
Subject: unaligned accesses in SLAB etc.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 11 Oct 2014 19:15:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm getting tons of the following on sparc64:

[603965.383447] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
[603965.396987] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
[603965.410523] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
[603965.424061] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
[603965.437617] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
[603970.554394] log_unaligned: 333 callbacks suppressed
[603970.564041] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
[603970.577576] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
[603970.591122] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
[603970.604669] Kernel unaligned access at TPC[546b60] free_block+0xa0/0x1a0
[603970.618216] Kernel unaligned access at TPC[546b58] free_block+0x98/0x1a0
[603976.515633] log_unaligned: 31 callbacks suppressed
[603976.525092] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603976.540196] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603976.555308] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603976.570411] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603976.585526] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603982.476424] log_unaligned: 43 callbacks suppressed
[603982.485881] Kernel unaligned access at TPC[549378] kmem_cache_alloc+0xd8/0x1e0
[603982.501590] Kernel unaligned access at TPC[5470a8] kmem_cache_free+0xc8/0x200
[603982.501605] Kernel unaligned access at TPC[549378] kmem_cache_alloc+0xd8/0x1e0
[603982.530382] Kernel unaligned access at TPC[5470a8] kmem_cache_free+0xc8/0x200
[603982.544820] Kernel unaligned access at TPC[549378] kmem_cache_alloc+0xd8/0x1e0
[603987.567130] log_unaligned: 11 callbacks suppressed
[603987.576582] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603987.591696] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603987.606811] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603987.621904] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
[603987.637017] Kernel unaligned access at TPC[548080] cache_alloc_refill+0x180/0x3a0
