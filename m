Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754130AbaFBLcc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 07:32:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:46862 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752784AbaFBLcb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 07:32:31 -0400
Date: Mon, 2 Jun 2014 04:32:28 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: Jens Axboe <axboe@kernel.dk>, Kent Overstreet <kmo@daterainc.com>,
        Shaohua Li <shli@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC] block: Eliminate first argument of submit_bio()
Message-ID: <20140602113228.GA26951@infradead.org>
References: <538C4767.5050207@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <538C4767.5050207@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 11:44:07AM +0200, Bart Van Assche wrote:
> The submit_bio() API is confusing. Merge functions like
> raid5_mergeable_bvec() can only work correctly if bi_rw is set
> before bio_add_page() has been called. submit_bio() modifies
> bi_rw after bio_add_page() has been called. Hence remove the
> first argument of submit_bio() and let the caller set bi_rw.
> Note: some but not all submit_bio() callers have been fixed
> such that bi_rw is set before bio_add_page() is called.

I like this a lot!

