Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751684AbaG3H4i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 03:56:38 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:59484 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034AbaG3H4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 03:56:35 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <53D8A52B.5000006@lge.com>
Date: Wed, 30 Jul 2014 16:56:27 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Peter Zijlstra <peterz@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Joonsoo Kim <js1304@gmail.com>, Minchan Kim <minchan@kernel.org>
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
References: <53CDF437.4090306@lge.com> <20140722073005.GT3935@laptop> <20140722081440.GA5137@thunk.org> <20140727010144.GA13438@thunk.org>
In-Reply-To: <20140727010144.GA13438@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-07-27 오전 10:01, Theodore Ts'o 쓴 글:
> Gioh,
>
> As follow up, if you want some further discussions about why these
> patches should be accepted, it would be good to get some hard data
> about why the keeping the ext4 superblock pinned is causing such a
> problem for page migation.  Can you give us more details about what
> the impact is of not having these patches?  And how it compres to
> other data structures which are currently allocated in the moveable
> area and tend to be pinned effectively indefinitely?
>
> Thanks,
>
> 						- Ted
>

I am very sorry to be late. I couldn't access the network for a week.

sb_bread() allocates page from movable area but the reference count of the buffer-head
that manages page should be zero to migrate the page.
Therefore brelase() should be called immediately after sb_bread() such like fat_fill_super().
But ext4 called brelse() when unmount the superblock.
The page cannot be movable until unmount.
CMA/HOTPLUG memory try to move the page but it fails.

If ext4 needs to keep buffer-cache of superblock until unmount,
it should allocated the page from non-movable area (because it can be a long time).
This patch try to do it.

I also sent an email to Jan Kara. Please refer it.

Thank you for your kindness.
Please inform me if you need any information.
