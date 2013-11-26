Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab3KZGJ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:09:26 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:38363 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab3KZGJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:09:23 -0500
Date: Mon, 25 Nov 2013 22:09:21 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        axboe@kernel.dk, Neil Brown <neilb@suse.de>,
        Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com
Subject: Re: [PATCH 1/5] block: Make generic_make_request handle arbitrary
 sized bios
Message-ID: <20131126060921.GB6434@infradead.org>
References: <1385418633-9753-1-git-send-email-kmo@daterainc.com>
 <1385418633-9753-2-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385418633-9753-2-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	q->bio_split = bioset_create(4, 0);
> +	if (!q->bio_split)
> +		goto fail_id;

How did we arrive at a mempool size of 4 to make sure we can always make
progress with arbitrarily sized bios?  Shouldn't we document the design
decision somewhere?

> +static struct bio *blk_bio_discard_split(struct request_queue *q,
> +					 struct bio *bio,
> +					 struct bio_set *bs)
> +{

One fallout of this should be that it would allows us to impement
a range UNMAP/TRIP much more easily, which would help dramatically
with TRIM performance!

