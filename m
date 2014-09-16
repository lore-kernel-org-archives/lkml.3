Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbaIPSYe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:24:34 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:46073 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753000AbaIPSYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:24:32 -0400
Date: Tue, 16 Sep 2014 11:24:31 -0700
From: Zach Brown <zab@zabbo.net>
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
Message-ID: <20140916182431.GJ19090@lenny.home.zabbo.net>
References: <cover.1410810247.git.milosz@adfin.com>
 <8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
 <94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 15, 2014 at 10:36:46PM +0000, Elliott, Robert (Server Storage) wrote:
> 
> 
> > -----Original Message-----
> > From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> > owner@vger.kernel.org] On Behalf Of Andreas Dilger
> > Sent: Monday, 15 September, 2014 4:34 PM
> > To: Milosz Tanski
> > Cc: linux-kernel@vger.kernel.org; Christoph Hellwig; linux-
> > fsdevel@vger.kernel.org; linux-aio@kvack.org; Mel Gorman; Volker Lendecke;
> > Tejun Heo; Jeff Moyer
> > Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
> > 
> > On Sep 15, 2014, at 2:20 PM, Milosz Tanski <milosz@adfin.com> wrote:
> > 
> > > This patcheset introduces an ability to perform a non-blocking read
> > > from regular files in buffered IO mode. This works by only for those
> > > filesystems that have data in the page cache.
> > >
> > > It does this by introducing new syscalls new syscalls readv2/writev2
> > > and preadv2/pwritev2. These new syscalls behave like the network sendmsg,
> > > recvmsg syscalls that accept an extra flag argument (O_NONBLOCK).
> > 
> > It's too bad that we are introducing yet another new read/write
> > syscall pair that only allow IO into discontiguous memory regions,
> > but do not allow a single call to access discontiguous file regions
> > (i.e. specify a separate file offset for each iov).
> > 
> > Adding syscalls similar to preadv/pwritev() that could take a iovec
> > that specified the file offset+length in addition to the memory address
> > would allow efficient scatter-gather IO in a single syscall.  While
> > that is less critical for local filesystems with small syscall latency,
> > it is more important for network filesystems, or in the case of
> > NVRAM-backed filesystems.
> > 
> > Cheers, Andreas
> 
> That sounds like the proposed WRITE SCATTERED/READ GATHERED 
> commands for SCSI (where are related to, but not necessarily
> tied to, atomic writes).  We discussed them a bit at 
> LSF-MM 2013 - see http://lwn.net/Articles/548116/.

It's the old {read,write}x proposals:

http://www.mcs.anl.gov/uploads/cels/papers/TM-302-FINAL.pdf

- z
