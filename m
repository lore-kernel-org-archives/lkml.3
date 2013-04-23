Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932153Ab3DWQgC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 12:36:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1631 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab3DWQfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 12:35:54 -0400
Date: Tue, 23 Apr 2013 12:35:51 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk
Subject: Re: NULL pointer due to malformed bcache bio
Message-ID: <20130423163551.GA9958@redhat.com>
References: <20130410205439.GA18092@redhat.com>
 <20130422212218.GA4704@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130422212218.GA4704@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 22 2013 at  5:22pm -0400,
Kent Overstreet <koverstreet@google.com> wrote:

> On Wed, Apr 10, 2013 at 04:54:40PM -0400, Mike Snitzer wrote:
> > Hey,
> > 
> > So DM core clearly needs to be more defensive about the possibility for
> > a NULL return from bio_alloc_bioset() given I'm hitting a NULL pointer
> > in DM's alloc_tio() because nr_iovecs=512.  bio_alloc_bioset()'s call to
> > bvec_alloc() only supports nr_iovecs up to BIO_MAX_PAGES (256).
> 
> I have a fix for this queued up in my bcache-for-upstream, if you want
> to check and make sure it works.

Works for me, thanks.
