Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751825AbaHPSwR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Aug 2014 14:52:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39510 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751589AbaHPSwP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Aug 2014 14:52:15 -0400
Date: Sat, 16 Aug 2014 20:52:08 +0200
From: Jan Kara <jack@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Gioh Kim <gioh.kim@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock in
 non-movable area
Message-ID: <20140816185208.GA1589@quack.suse.cz>
References: <53EC4531.1000904@lge.com>
 <20140814142610.6f0d4194c373fef188870772@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140814142610.6f0d4194c373fef188870772@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 14-08-14 14:26:10, Andrew Morton wrote:
> On Thu, 14 Aug 2014 14:12:17 +0900 Gioh Kim <gioh.kim@lge.com> wrote:
> 
> > This patch try to solve problem that a long-lasting page caches of
> > ext4 superblock and journaling of superblock disturb page migration.
> > 
> > I've been testing CMA feature on my ARM-based platform
> > and found that two page caches cannot be migrated.
> > They are page caches of superblock of ext4 filesystem and its journaling data.
> > 
> > Current ext4 reads superblock with sb_bread() that allocates page
> > from movable area. But the problem is that ext4 hold the page until
> > it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
> > And also the journaling data for the superblock cannot be migreated.
> > 
> > I introduce a new API for allocating page cache from non-movable area.
> > It is useful for ext4/ext3 and others that want to hold page cache for a long time.
> 
> All seems reasonable to me.  The additional overhead in buffer.c from
> additional function arguments is regrettable but I don't see a
> non-hacky alternative.
> 
> One vital question which the changelog doesn't really address (it
> should): how important is this patch?  Is your test system presently
> "completely dead in the water utterly unusable" or "occasionally not
> quite as good as it could be".  Somewhere in between?
  I would be also interested in how much these patches make things better.
Because I would expect all metadata that is currently journalled to be
unmovable as well.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
