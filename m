Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754504Ab3IEPfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 11:35:03 -0400
Received: from mga03.intel.com ([143.182.124.21]:60281 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754338Ab3IEPe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 11:34:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,847,1371106800"; 
   d="scan'208";a="356388078"
Date: Thu, 5 Sep 2013 11:34:47 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: rob.gittins@linux.intel.com, linux-pmfs@lists.infradead.org,
        linux-fsdevel@veger.org, linux-kernel@vger.kernel.org
Subject: Re: RFC Block Layer Extensions to Support NV-DIMMs
Message-ID: <20130905153447.GB20931@linux.intel.com>
References: <1378331689.9210.11.camel@Virt-Centos-6.lm.intel.com>
 <x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49y57ba2ne.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 05, 2013 at 08:12:05AM -0400, Jeff Moyer wrote:
> If the memory is available to be mapped into the address space of the
> kernel or a user process, then I don't see why we should have a block
> device at all.  I think it would make more sense to have a different
> driver class for these persistent memory devices.

We already have at least two block devices in the tree that provide
this kind of functionality (arch/powerpc/sysdev/axonram.c and
drivers/s390/block/dcssblk.c).  Looking at how they're written, it
seems like implementing either of them as a block device on top of a
character device that extended their functionality in the direction we
want would be a pretty major bloating factor for no real benefit (not
even a particularly cleaner architecture).

> > Different applications, filesystem and drivers may wish to share
> > ranges of PMEM.  This is analogous to partitioning a disk that is
> > using multiple and different filesystems.   Since PMEM is addressed
> > on a byte basis rather than a block basis the existing partitioning
> > model does not fit well.  As a result there needs to be a way to
> > describe PMEM ranges.
> >
> > 	struct pmem_layout *(*getpmem)(struct block_device *bdev);
> 
> If existing partitioning doesn't work well, then it sounds like a block
> device isn't the right fit (again).  Ignoring that detail, what about
> requesting and releasing ranges of persistent memory, as in your
> "partitioning" example?  Would that not also be a function of the
> driver?

"existing partitioning" doesn't even work well for existing drives!
Nobody actually builds a drive with fixed C/H/S any more.
