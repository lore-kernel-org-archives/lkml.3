Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab3GAJr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 05:47:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45133 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752745Ab3GAJrz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 05:47:55 -0400
Date: Mon, 1 Jul 2013 11:47:52 +0200
From: Jens Axboe <axboe@kernel.dk>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>
Subject: Re: [PATCH 0/9] dasd: implement block timeout
Message-ID: <20130701094752.GI15088@kernel.dk>
References: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
 <20130617092215.6c0df7d1@mschwide>
 <20130701102119.086396d5@mschwide>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130701102119.086396d5@mschwide>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 01 2013, Martin Schwidefsky wrote:
> On Mon, 17 Jun 2013 09:22:15 +0200
> Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> 
> > On Mon,  3 Jun 2013 17:03:13 +0200
> > Martin Schwidefsky <schwidefsky@de.ibm.com> wrote:
> > 
> > > This is a re-send of a patch series Hannes sent last january. Stefan
> > > looked at the patches and our tests went well, so I guess this is ready
> > > for upstream integration.
> > > 
> > > The changes to block/blk-core.c and block/blk-timeout.c look good
> > > to me, but I would like to request an acked-by from Jens for the
> > > block layer parts in patch #6 and #7 of the series (pretty please :-)
> > > 
> > > The original patch description from Hannes:
> > > 
> > > This patch series implements a block timeout handler for
> > > DASDs. The main impetus was to allow for a fixed upper
> > > timeout value after which a request is aborted.
> > > This is required eg when implementing a host-based
> > > mirroring system where otherwise the entire mirror
> > > would stall under certain circumstances.
> > > 
> > > Changes since v1:
> > > - Fixed lock inversion in dasd_times_out()
> > > - Checked for 'device->block' when writing to 'timeout' attribute
> > > - Check against 'UINT_MAX' when verifying the 'timeout' value
> > > 
> > > Once I got the required acked-by I can carry the patch set in the
> > > linux-s390 tree for the next merge window.
> > > 
> > > Hannes Reinecke (9):
> > >   dasd: Clarify comment
> > >   dasd: make number of retries configurable
> > >   dasd: process all requests in the device tasklet
> > >   dasd: Implement block timeout handling
> > >   dasd: Reduce amount of messages for specific errors
> > >   block,dasd: detailed I/O errors
> > >   block: check for timeout function in blk_rq_timed_out()
> > >   dasd: Add 'timeout' attribute
> > >   dasd: Fail all requests when DASD_FLAG_ABORTIO is set
> > > 
> > >  arch/s390/include/uapi/asm/dasd.h |    4 ++
> > >  block/blk-core.c                  |    3 +
> > >  block/blk-timeout.c               |    5 +-
> > >  drivers/s390/block/dasd.c         |  115 +++++++++++++++++++++++++++++++++----
> > >  drivers/s390/block/dasd_devmap.c  |   97 +++++++++++++++++++++++++++++++
> > >  drivers/s390/block/dasd_diag.c    |    8 ++-
> > >  drivers/s390/block/dasd_eckd.c    |   15 +++--
> > >  drivers/s390/block/dasd_erp.c     |    8 +++
> > >  drivers/s390/block/dasd_fba.c     |   10 +++-
> > >  drivers/s390/block/dasd_int.h     |   10 ++++
> > >  drivers/s390/block/dasd_ioctl.c   |   59 +++++++++++++++++++
> > >  11 files changed, 313 insertions(+), 21 deletions(-)
> > > 
> > 
> > Ping. Jens could you please look at patch #6 and #7? I don't want
> > to do a please pull with block layer parts without your consent.

Both look fine, you can add my acked-by.

-- 
Jens Axboe

