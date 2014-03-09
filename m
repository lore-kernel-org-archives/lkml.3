Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaCIDaV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Mar 2014 22:30:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751897AbaCIDaT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Mar 2014 22:30:19 -0500
Date: Sat, 8 Mar 2014 22:29:46 -0500
From: Mike Snitzer <snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.de>, Mike Snitzer <snitzer@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        Shaohua Li <shli@fusionio.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: block: fix q->flush_rq NULL pointer crash on dm-mpath flush
Message-ID: <20140309032946.GA19029@redhat.com>
References: <x49iorp3fhm.fsf@segfault.boston.devel.redhat.com>
 <20140308155240.GA32297@infradead.org>
 <CAMM=eLewbtK7LiNZCXo=hm-sjVU2+MN+xTFuxb89mDA1iS3r0w@mail.gmail.com>
 <531B74B6.4070004@suse.de>
 <CAMM=eLfVpc=B7ZzxBDbKW4GZ_E5rOqrcbyppNBSz_brQaH4VNw@mail.gmail.com>
 <531B8CB1.2010502@suse.de>
 <20140308220926.GA15421@redhat.com>
 <531BB4A9.5000305@kernel.dk>
 <20140309005729.GA18321@redhat.com>
 <531BDD77.5020809@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <531BDD77.5020809@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08 2014 at 10:18pm -0500,
Jens Axboe <axboe@kernel.dk> wrote:

> On 2014-03-08 17:57, Mike Snitzer wrote:
> >
> >I had a look at what you queued, thing is commit 1874198 replaced code
> >in blk_kick_flush() that did use list_add_tail().  So getting back to
> >the way the original code  was (before 1874198) would need something
> >like the following patch.
> >
> >But it isn't clear to me why we'd have the duality of front vs tail
> >additions for flushes.  Maybe Christoph knows?
> 
> Not sure it'd even make a difference with the use case, but always
> tail would be broken. But the flushing in general is a bit of a
> nightmare, so I'd be inclined to add your full fix too, at least
> this late in -rc.

OK, please feel free to add my Signed-off-by.
