Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752361AbaKKGoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 01:44:23 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:51868 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751398AbaKKGoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 01:44:21 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsglAMOvYVR5LbBUPGdsb2JhbABcgw6BLYI2hQewewaVLoVsBAICgRoXAQEBAQEGAQEBATg7hAMBAQQ6HCMQCAMYCSUPBSUDBxoTiEDMdgELIBiGIopbB4RLBZAOjhaBNYcBkjkpL4JLAQEB
Date: Tue, 11 Nov 2014 17:44:17 +1100
From: Dave Chinner <david@fromorbit.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-api@vger.kernel.org,
        Michael Kerrisk <mtk.manpages@gmail.com>, linux-arch@vger.kernel.org
Subject: Re: [PATCH v6 0/7] vfs: Non-blockling buffered fs read (page cache
 only)
Message-ID: <20141111064417.GT23575@dastard>
References: <cover.1415636409.git.milosz@adfin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1415636409.git.milosz@adfin.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 11:40:23AM -0500, Milosz Tanski wrote:
> This patcheset introduces an ability to perform a non-blocking read from
> regular files in buffered IO mode. This works by only for those filesystems
> that have data in the page cache.
> 
> It does this by introducing new syscalls new syscalls preadv2/pwritev2. These
> new syscalls behave like the network sendmsg, recvmsg syscalls that accept an
> extra flag argument (RWF_NONBLOCK).
> 
> It's a very common patern today (samba, libuv, etc..) use a large threadpool to
> perform buffered IO operations. They submit the work form another thread
> that performs network IO and epoll or other threads that perform CPU work. This
> leads to increased latency for processing, esp. in the case of data that's
> already cached in the page cache.
> 
> With the new interface the applications will now be able to fetch the data in
> their network / cpu bound thread(s) and only defer to a threadpool if it's not
> there. In our own application (VLDB) we've observed a decrease in latency for
> "fast" request by avoiding unnecessary queuing and having to swap out current
> tasks in IO bound work threads.

Can you write a test (or set of) for fstests that exercises this new
functionality? I'm not worried about performance, just
correctness....

Cheers,

Dave.

-- 
Dave Chinner
david@fromorbit.com
