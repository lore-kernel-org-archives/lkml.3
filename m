Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932317AbaHNV0O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 17:26:14 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33823 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163AbaHNV0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 17:26:12 -0400
Date: Thu, 14 Aug 2014 14:26:10 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?UTF-8?Q?=EC=9D=B4?= =?UTF-8?Q?=EA=B1=B4=ED=98=B8?= 
	<gunho.lee@lge.com>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock in
 non-movable area
Message-Id: <20140814142610.6f0d4194c373fef188870772@linux-foundation.org>
In-Reply-To: <53EC4531.1000904@lge.com>
References: <53EC4531.1000904@lge.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Aug 2014 14:12:17 +0900 Gioh Kim <gioh.kim@lge.com> wrote:

> This patch try to solve problem that a long-lasting page caches of
> ext4 superblock and journaling of superblock disturb page migration.
> 
> I've been testing CMA feature on my ARM-based platform
> and found that two page caches cannot be migrated.
> They are page caches of superblock of ext4 filesystem and its journaling data.
> 
> Current ext4 reads superblock with sb_bread() that allocates page
> from movable area. But the problem is that ext4 hold the page until
> it is unmounted. If root filesystem is ext4 the page cannot be migrated forever.
> And also the journaling data for the superblock cannot be migreated.
> 
> I introduce a new API for allocating page cache from non-movable area.
> It is useful for ext4/ext3 and others that want to hold page cache for a long time.

All seems reasonable to me.  The additional overhead in buffer.c from
additional function arguments is regrettable but I don't see a
non-hacky alternative.


One vital question which the changelog doesn't really address (it
should): how important is this patch?  Is your test system presently
"completely dead in the water utterly unusable" or "occasionally not
quite as good as it could be".  Somewhere in between?

See, the patch adds costs.  I'd like us to have a good understanding of
what benefits it brings.

