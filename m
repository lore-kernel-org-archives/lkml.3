Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338Ab3DVVWZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 17:22:25 -0400
Received: from mail-ia0-f182.google.com ([209.85.210.182]:46250 "EHLO
	mail-ia0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823Ab3DVVWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 17:22:23 -0400
Date: Mon, 22 Apr 2013 14:22:18 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk
Subject: Re: NULL pointer due to malformed bcache bio
Message-ID: <20130422212218.GA4704@localhost>
References: <20130410205439.GA18092@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130410205439.GA18092@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 04:54:40PM -0400, Mike Snitzer wrote:
> Hey,
> 
> So DM core clearly needs to be more defensive about the possibility for
> a NULL return from bio_alloc_bioset() given I'm hitting a NULL pointer
> in DM's alloc_tio() because nr_iovecs=512.  bio_alloc_bioset()'s call to
> bvec_alloc() only supports nr_iovecs up to BIO_MAX_PAGES (256).

I have a fix for this queued up in my bcache-for-upstream, if you want
to check and make sure it works.
