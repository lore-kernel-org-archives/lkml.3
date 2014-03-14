Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaCNNXa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 09:23:30 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42572 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753432AbaCNNX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 09:23:29 -0400
Date: Fri, 14 Mar 2014 06:23:23 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dm-devel@redhat.com
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140314132323.GA14606@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
 <20140314092519.GA10139@infradead.org>
 <20140314130021.GA12589@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140314130021.GA12589@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 14, 2014 at 09:00:21AM -0400, Mike Snitzer wrote:
> > Getting a little upset, eh?  I didn't say it's broken, I said it gets
> > very little testing.  The regression from me was found like so many
> > before only after it was backported o some enterprise kernel.
> 
> Even _really_ basic dm-multipath testing would've uncovered this bug.

But major testing using dm, md and various low-level drivers didn't.  Do
you really expect everyone to remember to specificly test dm-multipath
for a core block change?  Without a nicely documented way to do it?

That being said I should have remembered that it's special, but even I
didn't and I'm sorry about that.

> > I think the problem here is two-fold:
> >  a) the hardware you use with dm-multipath isn't widely available.
> >  b) it uses a very special code path in the block layer no one else uses
> > 
> > a) might be fixable by having some RDAC or similar emulation in qemu if
> > someone wants to spend the effort.
> 
> The regression from the commit in question was easily reproduced/tested
> using scsi_debug.  Just start the multipathd service and any scsi_debug
> device in the system will get multipath'd.

Really?  That sounds a like a bug in the INQUIRY information returned by
scsi_debug.  Either way please write up these things in Documentation so
you can point people at it easily.

