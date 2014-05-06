Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933858AbaEFDZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 23:25:54 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:36032 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933740AbaEFDZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 23:25:52 -0400
Date: Mon, 05 May 2014 23:25:50 -0400 (EDT)
Message-Id: <20140505.232550.1139149215179650645.davem@davemloft.net>
To: sam@ravnborg.org
Cc: linux-kernel@vger.kernel.org, iamjoonsoo.kim@lge.com,
        sparclinux@vger.kernel.org, hannes@cmpxchg.org, cl@linux.com,
        penberg@kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] slab: Fix off by one in object max number tests.
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140505.170855.814445464231092040.davem@davemloft.net>
References: <20140505.165756.1229178386133288960.davem@davemloft.net>
	<20140505210507.GA5130@ravnborg.org>
	<20140505.170855.814445464231092040.davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 05 May 2014 20:25:52 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 05 May 2014 17:08:55 -0400 (EDT)

> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Mon, 5 May 2014 23:05:07 +0200
> 
>> On Mon, May 05, 2014 at 04:57:56PM -0400, David Miller wrote:
>>> From: David Miller <davem@davemloft.net>
>>> Date: Mon, 05 May 2014 16:20:04 -0400 (EDT)
>>> 
>>> > 
>>> > If freelist_idx_t is a byte, SLAB_OBJ_MAX_NUM should be 255 not 256,
>>> > and likewise if freelist_idx_t is a short, then it should be 65535 not
>>> > 65536.
>>> > 
>>> > Fixes: a41adfa ("slab: introduce byte sized index for the freelist of a slab")
>>> > Signed-off-by: David S. Miller <davem@davemloft.net>
>>> > ---
>>> > 
>>> > This was leading to all kinds of random crashes on sparc64 where PAGE_SIZE
>>> > is 8192.  One problem shown was that if spinlock debugging was enabled,
>>> > we'd get deadlocks in copy_pte_range() or do_wp_page() with the same cpu
>>> > already holding a lock it shouldn't hold, or the lock belonging to a
>>> > completely unrelated process.
>>> 
>>> It turns out that after some more testing, I'm still getting spinlock
>>> debugging problems with this fix applied.
>>> 
>>> The change is still very much correct I think, however.
>> 
>> There is a related patch in this area which I think is not yet applied.
>> 
>> See: https://lkml.org/lkml/2014/4/18/28
>> 
>> Maybe this is realted.
> 
> Thanks, I'm testing with that patch added as well.

I can confirm that this fixes my problems completely.
