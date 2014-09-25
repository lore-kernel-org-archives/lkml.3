Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752592AbaIYLRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 07:17:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:37776 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752194AbaIYLQ7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 07:16:59 -0400
Date: Thu, 25 Sep 2014 13:16:55 +0200
From: Jan Kara <jack@suse.cz>
To: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Milosz Tanski <milosz@adfin.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-aio <linux-aio@kvack.org>, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux API <linux-api@vger.kernel.org>
Subject: Re: [RFC v3 0/4] vfs: Non-blockling buffered fs read (page cache
 only)
Message-ID: <20140925111655.GA8169@quack.suse.cz>
References: <cover.1410810247.git.milosz@adfin.com>
 <cover.1411594644.git.milosz@adfin.com>
 <CAHO5Pa2AbW+ndgUBjjB==NnwQjVuvbYaYdW8v0x-CjYYQEr9AA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHO5Pa2AbW+ndgUBjjB==NnwQjVuvbYaYdW8v0x-CjYYQEr9AA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 25-09-14 06:06:14, Michael Kerrisk wrote:
> Hello Milosz,
> 
> On Wed, Sep 24, 2014 at 11:46 PM, Milosz Tanski <milosz@adfin.com> wrote:
> > This patcheset introduces an ability to perform a non-blocking read from
> > regular files in buffered IO mode. This works by only for those filesystems
> > that have data in the page cache.
> >
> > It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
> > new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
> > extra flag argument (RWF_NONBLOCK).
> >
> > It's a very common patern today (samba, libuv, etc..) use a large threadpool to
> > perform buffered IO operations. They submit the work form another thread
> > that performs network IO and epoll or other threads that perform CPU work. This
> > leads to increased latency for processing, esp. in the case of data that's
> > already cached in the page cache.
> >
> > With the new interface the applications will now be able to fetch the data in
> > their network / cpu bound thread(s) and only defer to a threadpool if it's not
> > there. In our own application (VLDB) we've observed a decrease in latency for
> > "fast" request by avoiding unnecessary queuing and having to swap out current
> > tasks in IO bound work threads.
> 
> Since this is a change to the user-space API, could you CC future
> versions of this patch set to linux-api@vgerr.kernel.org please, as
  There's typo in the address. It should be:
linux-api@vger.kernel.org

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
