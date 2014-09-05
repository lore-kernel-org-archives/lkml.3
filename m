Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752562AbaIEQES (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 12:04:18 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:57206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbaIEQER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 12:04:17 -0400
Date: Fri, 5 Sep 2014 09:04:13 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Milosz Tanski <milosz@adfin.com>, LKML <linux-kernel@vger.kernel.org>,
        Volker Lendecke <Volker.Lendecke@SerNet.DE>, Tejun Heo <tj@kernel.org>,
        linux-aio@kvack.org
Subject: Re: read()/readv() only from page cache
Message-ID: <20140905160413.GA28285@infradead.org>
References: <CANP1eJGE=vQBdLnMBFPcTWrvh+dUA-UCK=ugO-tc2KN4LWLPSA@mail.gmail.com>
 <20140905110927.GI17501@suse.de>
 <20140905154829.GA22956@infradead.org>
 <x49r3zqxdh0.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49r3zqxdh0.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 05, 2014 at 12:02:19PM -0400, Jeff Moyer wrote:
> > One further consideration would be to finally implement real buffered
> > I/O in kernel space by something like the above and offloading to
> > workqueues in kernelspace.  I think our workqueues now are way better
> > than any possible user thread pool, although we'd need to find a way to
> > temporarily tie the work threads to a user address space.
> 
> Do you mean real buffered AIO?

Yes.

