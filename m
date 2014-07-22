Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191AbaGVIO7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 04:14:59 -0400
Received: from imap.thunk.org ([74.207.234.97]:49178 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753350AbaGVIOz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 04:14:55 -0400
Date: Tue, 22 Jul 2014 04:14:40 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Gioh Kim <gioh.kim@lge.com>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andreas Dilger <adilger.kernel@dilger.ca>, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 0/2] new API to allocate buffer-cache for superblock in
 non-movable area
Message-ID: <20140722081440.GA5137@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Peter Zijlstra <peterz@infradead.org>, Gioh Kim <gioh.kim@lge.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	linux-ext4@vger.kernel.org
References: <53CDF437.4090306@lge.com>
 <20140722073005.GT3935@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722073005.GT3935@laptop>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 09:30:05AM +0200, Peter Zijlstra wrote:
> > I introduce a new API for allocating page from non-movable area.
> > It is useful for ext4 and others that want to hold page cache for a long time.
> 
> There's no word on why you can't teach ext4 to still migrate that page.
> For all I know it might be impossible, but at least mention why.

In theory we might be able to do it, but it's only a single 4k page,
and we'd have to add RCU locking all over the place in order to be
able to switch out the superblock structure, since we reference it all
over the place inside fs/ext4.  The question I'd ask is is it worth
it.

I suspect the bigger deal is that there are all sorts of inodes and
dentries which are effectively pinned and thus, impossible to migrate.
This probably locks down many more pages (by a fact of at least 10 or
20), and I'd think that's something you would be much more interested
in fixing.

	      	       	    	 	       - Ted
