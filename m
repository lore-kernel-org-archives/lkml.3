Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab3FIIzU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 04:55:20 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:63929 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752165Ab3FIIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 04:55:18 -0400
Date: Sun, 9 Jun 2013 01:55:14 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jens Axboe <axboe@kernel.dk>, "Theodore Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: Re: Immutable biovecs, dio rewrite
Message-ID: <20130609085514.GA24643@localhost>
References: <1370744348-15407-1-git-send-email-koverstreet@google.com>
 <CAMuHMdXsnNMGUNKXaoUYCNnrCi2jv-acktzF_+g0yfEm7Lo-Og@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXsnNMGUNKXaoUYCNnrCi2jv-acktzF_+g0yfEm7Lo-Og@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 09, 2013 at 10:34:08AM +0200, Geert Uytterhoeven wrote:
> On Sun, Jun 9, 2013 at 4:18 AM, Kent Overstreet <koverstreet@google.com> wrote:
> >  * Changing all the drivers to go through the iterator means that we can
> >    submit a partially completed bio to generic_make_request() - this
> >    previously worked on some drivers, but worked on others.
> 
> Some negation is missing in this sentence?

Heh, whoops.

Yeah, it seemed to work fine on normal request queue based drivers - and
expecting the driver to respect the current value of bi_idx isn't really
a crazy thing - but it breaks with other drivers. Both bcache and md
have hacks to work around this (c.f. md_trim_bio()) but those hacks have
downsides (you have to either modify the biovec, or clone the whole bio
and biovec).

But if drivers are using the bvec iterator primitives so they don't
modify the biovec, we get this for free.
