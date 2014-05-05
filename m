Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569AbaEEU57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 16:57:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33650 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370AbaEEU56 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 16:57:58 -0400
Date: Mon, 05 May 2014 16:57:56 -0400 (EDT)
Message-Id: <20140505.165756.1229178386133288960.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
Cc: iamjoonsoo.kim@lge.com, sparclinux@vger.kernel.org, hannes@cmpxchg.org,
        cl@linux.com, penberg@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] slab: Fix off by one in object max number tests.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140505.162004.1797345518474659123.davem@davemloft.net>
References: <20140505.162004.1797345518474659123.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 13:57:58 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 05 May 2014 16:20:04 -0400 (EDT)

> 
> If freelist_idx_t is a byte, SLAB_OBJ_MAX_NUM should be 255 not 256,
> and likewise if freelist_idx_t is a short, then it should be 65535 not
> 65536.
> 
> Fixes: a41adfa ("slab: introduce byte sized index for the freelist of a slab")
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
> 
> This was leading to all kinds of random crashes on sparc64 where PAGE_SIZE
> is 8192.  One problem shown was that if spinlock debugging was enabled,
> we'd get deadlocks in copy_pte_range() or do_wp_page() with the same cpu
> already holding a lock it shouldn't hold, or the lock belonging to a
> completely unrelated process.

It turns out that after some more testing, I'm still getting spinlock
debugging problems with this fix applied.

The change is still very much correct I think, however.
