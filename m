Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251AbaISLX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:23:58 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59076 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaISLX5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:23:57 -0400
Date: Fri, 19 Sep 2014 04:23:55 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: Milosz Tanski <milosz@adfin.com>, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        michael.kerrisk@gmail.com
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
Message-ID: <20140919112355.GB4639@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <x49d2awr1ez.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49d2awr1ez.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 05:58:44PM -0400, Jeff Moyer wrote:
> I thought you were going to introduce a new flag instead of using
> O_NONBLOCK for this.  I dug up an old email that suggested that enabling
> O_NONBLOCK for regular files (well, a device node in this case) broke a
> cd ripping or burning application.  I also found this old bugzilla,
> which states that squid would fail to start, and that gqview was also
> broken:
>   https://bugzilla.redhat.com/show_bug.cgi?id=136057

That is why we avoid looking a the per-open O_NONBLOCK flag, and only
apply it per I/O.  As mentioned in my last mail it's not quite as
trivial but still fairly easy to also do that for writes.

> I don't think O_NONBLOCK is the right flag.  What you're really
> specifying is a flag that prevents I/O in the read path, and nowhere
> else.  As such, I'd feel much better about this if we defined a new flag
> (O_NONBLOCK_READ maybe?  No, that's too verbose.).
> 
> In summary, I like the idea, but I worry about overloading O_NONBLOCK.

There's a fair argument we could use a different namespace for the
per-I/O ops, and it seems like Miklos already implemented this for the
next version.
