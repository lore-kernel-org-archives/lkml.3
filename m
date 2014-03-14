Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920AbaCNJZ3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 05:25:29 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40219 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755896AbaCNJZ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 05:25:27 -0400
Date: Fri, 14 Mar 2014 02:25:19 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Mike Snitzer <snitzer@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>,
        Jeff Moyer <jmoyer@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] block: rework flush sequencing for blk-mq
Message-ID: <20140314092519.GA10139@infradead.org>
References: <20140130132620.GA6031@infradead.org>
 <20140130132630.GB6031@infradead.org>
 <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <20140312102849.GA26509@infradead.org>
 <20140313161347.GA6598@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140313161347.GA6598@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:13:47PM -0400, Mike Snitzer wrote:
> Pretty ironic that in the same email that you ask someone to "Let's make
> this a little less personal." you start by asserting upstream
> dm-multipath sees very little testing -- and use your commit that
> recently broke dm-multipath as the basis.  Anyway, please exapnd on what
> you feel is broken with upstream dm-multipath.

Getting a little upset, eh?  I didn't say it's broken, I said it gets
very little testing.  The regression from me was found like so many
before only after it was backported o some enterprise kernel.

I think the problem here is two-fold:
 a) the hardware you use with dm-multipath isn't widely available.
 b) it uses a very special code path in the block layer no one else uses

a) might be fixable by having some RDAC or similar emulation in qemu if
someone wants to spend the effort.
b) is a bit harder, but we should think hard about it when rewriting the
multipath code to support blk-mq.  Talking about which I think trying to
use dm-multipath on any blk-mq device will go horribly crash and boom at
the moment.
