Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759193AbaIOWia (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:38:30 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:35911 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756859AbaIOWi0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:38:26 -0400
From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
To: Andreas Dilger <adilger@dilger.ca>, Milosz Tanski <milosz@adfin.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Christoph Hellwig" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: RE: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
Thread-Topic: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache
 only)
Thread-Index: AQHP0SKGxsA+DTFen0Wh6Y6YnaKzXpwCtzGAgAANsvA=
Date: Mon, 15 Sep 2014 22:36:46 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402958C81D56@G9W0745.americas.hpqcorp.net>
References: <cover.1410810247.git.milosz@adfin.com>
 <8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
In-Reply-To: <8EC2A7F3-0E25-4054-9863-4488B8ED5C8D@dilger.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-
> owner@vger.kernel.org] On Behalf Of Andreas Dilger
> Sent: Monday, 15 September, 2014 4:34 PM
> To: Milosz Tanski
> Cc: linux-kernel@vger.kernel.org; Christoph Hellwig; linux-
> fsdevel@vger.kernel.org; linux-aio@kvack.org; Mel Gorman; Volker Lendecke;
> Tejun Heo; Jeff Moyer
> Subject: Re: [RFC PATCH 0/7] Non-blockling buffered fs read (page cache only)
> 
> On Sep 15, 2014, at 2:20 PM, Milosz Tanski <milosz@adfin.com> wrote:
> 
> > This patcheset introduces an ability to perform a non-blocking read
> > from regular files in buffered IO mode. This works by only for those
> > filesystems that have data in the page cache.
> >
> > It does this by introducing new syscalls new syscalls readv2/writev2
> > and preadv2/pwritev2. These new syscalls behave like the network sendmsg,
> > recvmsg syscalls that accept an extra flag argument (O_NONBLOCK).
> 
> It's too bad that we are introducing yet another new read/write
> syscall pair that only allow IO into discontiguous memory regions,
> but do not allow a single call to access discontiguous file regions
> (i.e. specify a separate file offset for each iov).
> 
> Adding syscalls similar to preadv/pwritev() that could take a iovec
> that specified the file offset+length in addition to the memory address
> would allow efficient scatter-gather IO in a single syscall.  While
> that is less critical for local filesystems with small syscall latency,
> it is more important for network filesystems, or in the case of
> NVRAM-backed filesystems.
> 
> Cheers, Andreas

That sounds like the proposed WRITE SCATTERED/READ GATHERED 
commands for SCSI (where are related to, but not necessarily
tied to, atomic writes).  We discussed them a bit at 
LSF-MM 2013 - see http://lwn.net/Articles/548116/.


---
Rob Elliott    HP Server Storage





