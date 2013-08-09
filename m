Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031065Ab3HIUep (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 16:34:45 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:32188 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030995Ab3HIUeo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 16:34:44 -0400
Date: Fri, 9 Aug 2013 15:34:41 -0500
From: scameron@beardog.cce.hp.com
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: linux-kernel@vger.kernel.org, jens.axboe@kernel.dk, tj@kernel.org,
        scameron@beardog.cce.hp.com
Subject: Re: Question about REQ_FLUSH and bios with data
Message-ID: <20130809203441.GN9905@beardog.cce.hp.com>
References: <20130809190934.GL9905@beardog.cce.hp.com> <1376079495.2718.15.camel@menhir>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1376079495.2718.15.camel@menhir>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 09, 2013 at 09:18:15PM +0100, Steven Whitehouse wrote:
> Hi,
> 
> On Fri, 2013-08-09 at 14:09 -0500, scameron@beardog.cce.hp.com wrote:
> > So, I'm working on a block driver using the make_request_fn
> > interface, and have to handle a bio that comes in with
> > (bi_rw & REQ_FLUSH) set AND data to transfer. 
> > 
> > According to Documentation/block/writeback_cache_control.txt:
> > 
> > 	The REQ_FLUSH flag can be OR ed into the r/w flags of a
> > 	bio submitted from the filesystem and will make sure the
> > 	volatile cache of the storage device has been flushed
> > 	before the actual I/O operation is started. 
> > 
> > So I've written code that handles that case, along with the
> > various error cases I might encounter, I think, which leads
> > to my question:
> > 
> > How do I get such a bio with a data transfer AND the REQ_FLUSH bit
> > set to come into the driver?   Just wondering how to test this case.
> > 
> GFS2 does this... if you look at the log flush code and the function
> log_write_header() in particular, you'll see that it sets this on each
> log header that gets written. You don't need a cluster to generate this
> kind of i/o, just supply mkfs.gfs2 with -p lock_nolock and mount it as a
> local filesystem. The combination of touch foo; sync should be enough to
> generate a log flush writing a log header with this flag set,

Thanks!

Turns out ext3 seems to do it as well (now I feel kind of dumb
for asking -- had tried with ext2, and had tried some writes
with a file descriptor with O_SYNC set, but I was kind of shooting
in the dark.)

And my code appears to work too.

-- steve

