Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaISLV5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 07:21:57 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:59023 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755831AbaISLVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:21:51 -0400
Date: Fri, 19 Sep 2014 04:21:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Cc: Andreas Dilger <adilger@dilger.ca>, Milosz Tanski <milosz@adfin.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
Message-ID: <20140919112147.GA4639@infradead.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
 <94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 10:36:46PM +0000, Elliott, Robert (Server Storage) wrote:
> That sounds like the proposed WRITE SCATTERED/READ GATHERED 
> commands for SCSI (where are related to, but not necessarily
> tied to, atomic writes).  We discussed them a bit at 
> LSF-MM 2013 - see http://lwn.net/Articles/548116/.

In the same way a preadx/pwritex could use but would not require an
O_ATOMIC.  What's the status of those in t10?  Last I heard
READ GATHERED was out and they were only looking into WRITE SCATTERED?

Without the atomic WRITE SCATTERED use case adding the syscalls seems
rather pointless, and I'd really avoid blocking nice software only
features like the per-I/O nonblock flag (and the similarly trivial
per-I/O sync option I have a prototype for) on it.

Speaking of easy flags:  while a nonblock flags for writes wouldn't
be anywhere near as easy as the one for reads would there be sufficient
interested in it to bother implementing it?
