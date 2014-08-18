Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933AbaHRDYh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Aug 2014 23:24:37 -0400
Received: from imap.thunk.org ([74.207.234.97]:36240 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbaHRDYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Aug 2014 23:24:34 -0400
Date: Sun, 17 Aug 2014 23:24:22 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Gioh Kim <gioh.kim@lge.com>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org,
        Minchan Kim <minchan@kernel.org>, Joonsoo Kim <js1304@gmail.com>,
        =?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
Subject: Re: [PATCH 0/2] new APIs to allocate buffer-cache for superblock in
 non-movable area
Message-ID: <20140818032422.GD23084@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Gioh Kim <gioh.kim@lge.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Peter Zijlstra <peterz@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org, Minchan Kim <minchan@kernel.org>,
	Joonsoo Kim <js1304@gmail.com>,
	=?utf-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>
References: <53EC4531.1000904@lge.com>
 <20140814142610.6f0d4194c373fef188870772@linux-foundation.org>
 <20140816185208.GA1589@quack.suse.cz>
 <53F153B4.1060309@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53F153B4.1060309@lge.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2014 at 10:15:32AM +0900, Gioh Kim wrote:
> 
> My test platform has totally 1GB memory, 256MB for CMA and 768MB for normal.
> I applied Joonsoo's patch: https://lkml.org/lkml/2014/5/28/64, so that
> 3/4 of allocation take place in normal area and 1/4 allocation take place in CMA area.
> 
> And my platform has 4 ext4 partitions. Each ext4 partition has 2 page caches for superblock that
> are what this patch tries to move to out of CMA area.
> Therefore there are 8 page caches (8 pages size) that can prevent page migration.

Yes, but are you actually *using* the ext4 partitions for anything?
If this is a realistic real world use case, file systems are used to
store, well, files, and that means there will be inodes and dentry
cache entries that will also be allocated.  Does your test scenario
reflect real world usage?

Cheers,

						- Ted
