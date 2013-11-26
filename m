Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab3KZHVB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 02:21:01 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:40849 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753948Ab3KZHVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 02:21:00 -0500
Date: Mon, 25 Nov 2013 23:21:28 -0800
From: Kent Overstreet <kmo@daterainc.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH 1/5] block: Make generic_make_request handle arbitrary
 sized bios
Message-ID: <20131126072128.GF9244@kmo-pixel>
References: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
 <1385418633-9753-2-git-send-email-kmo@daterainc.com>
 <20131126060921.GB6434@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131126060921.GB6434@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 25, 2013 at 10:09:21PM -0800, Christoph Hellwig wrote:
> > +	q->bio_split = bioset_create(4, 0);
> > +	if (!q->bio_split)
> > +		goto fail_id;
> 
> How did we arrive at a mempool size of 4 to make sure we can always make
> progress with arbitrarily sized bios?  Shouldn't we document the design
> decision somewhere?

It just has to be nonzero to guarantee forward progress - the
bio_alloc_bioset() rescuer thing I did awhile back guarantees that.

> > +static struct bio *blk_bio_discard_split(struct request_queue *q,
> > +					 struct bio *bio,
> > +					 struct bio_set *bs)
> > +{
> 
> One fallout of this should be that it would allows us to impement
> a range UNMAP/TRIP much more easily, which would help dramatically
> with TRIM performance!

Cool!
