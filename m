Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161104Ab3FUJA1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 05:00:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38831 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758279Ab3FUJAZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 05:00:25 -0400
Date: Fri, 21 Jun 2013 11:00:21 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Glauber Costa <glommer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: slab shrinkers: BUG at mm/list_lru.c:92
Message-ID: <20130621090021.GB12424@dhcp22.suse.cz>
References: <20130617141822.GF5018@dhcp22.suse.cz>
 <20130617151403.GA25172@localhost.localdomain>
 <20130617143508.7417f1ac9ecd15d8b2877f76@linux-foundation.org>
 <20130617223004.GB2538@localhost.localdomain>
 <20130618062623.GA20528@localhost.localdomain>
 <20130619071346.GA9545@dhcp22.suse.cz>
 <20130619142801.GA21483@dhcp22.suse.cz>
 <20130620141136.GA3351@localhost.localdomain>
 <20130620151201.GD27196@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130620151201.GD27196@dhcp22.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-06-13 17:12:01, Michal Hocko wrote:
> I am bisecting it again. It is quite tedious, though, because good case
> is hard to be sure about.

OK, so now I converged to 2d4fc052 (inode: convert inode lru list to generic lru
list code.) in my tree and I have double checked it matches what is in
the linux-next. This doesn't help much to pin point the issue I am
afraid :/

I have applied the inode_lru_isolate fix on each step.
$ git bisect log
git bisect start
# bad: [d02c11c146b626cf8e2586446773ba02999e4e2f] mm/sparse.c: put clear_hwpoisoned_pages within CONFIG_MEMORY_HOTREMOVE
git bisect bad d02c11c146b626cf8e2586446773ba02999e4e2f
# good: [58f6e0c8fb37e8e37d5ac17a61a53ac236c15047] Reverted "mm: tlb_fast_mode check missing in tlb_finish_mmu()"
git bisect good 58f6e0c8fb37e8e37d5ac17a61a53ac236c15047
# bad: [4ec7ecd30d643b12e1041226ff180da3d88918ee] include/linux/math64.h: add div64_ul()
git bisect bad 4ec7ecd30d643b12e1041226ff180da3d88918ee
# bad: [96dd4e69dc50c7ed18e407798f7f677fa5588eae] xfs: convert dquot cache lru to list_lru
git bisect bad 96dd4e69dc50c7ed18e407798f7f677fa5588eae
# bad: [2d4fc052823c2f598f03633e64bc0439cd2bfa04] inode: convert inode lru list to generic lru list code.
git bisect bad 2d4fc052823c2f598f03633e64bc0439cd2bfa04
# good: [cacbac6d9d80cc5277e8f67c7a474edb6488a5ea] dcache: remove dentries from LRU before putting on dispose list
git bisect good cacbac6d9d80cc5277e8f67c7a474edb6488a5ea
# good: [03a05514e71551bfdff1e3496a30b0fd5083f8fe] shrinker: convert superblock shrinkers to new API
git bisect good 03a05514e71551bfdff1e3496a30b0fd5083f8fe
# good: [ddc5bc7a8856e0e61ea9c2d4fcbcd3f85ecc92e7] list: add a new LRU list type
git bisect good ddc5bc7a8856e0e61ea9c2d4fcbcd3f85ecc92e7
-- 
Michal Hocko
SUSE Labs
