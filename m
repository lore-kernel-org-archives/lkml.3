Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753388AbaGVHaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 03:30:16 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:37404 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbaGVHaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 03:30:14 -0400
Date: Tue, 22 Jul 2014 09:30:05 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Message-ID: <20140722073005.GT3935@laptop>
References: <53CDF437.4090306@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CDF437.4090306@lge.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 02:18:47PM +0900, Gioh Kim wrote:
> Hello,
> 
> This patch try to solve problem that a long-lasting page cache of
> ext4 superblock disturbs page migration.
> 
> I've been testing CMA feature on my ARM-based platform
> and found some pages for page caches cannot be migrated.
> Some of them are page caches of superblock of ext4 filesystem.
> 
> Current ext4 reads superblock with sb_bread(). sb_bread() allocates page
> from movable area. But the problem is that ext4 hold the page until
> it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
> 
> I introduce a new API for allocating page from non-movable area.
> It is useful for ext4 and others that want to hold page cache for a long time.

There's no word on why you can't teach ext4 to still migrate that page.
For all I know it might be impossible, but at least mention why.
