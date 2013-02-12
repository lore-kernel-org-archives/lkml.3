Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969Ab3BLBdv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 20:33:51 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44927 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab3BLBdt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 20:33:49 -0500
Date: Mon, 11 Feb 2013 17:33:15 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>, Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH][WIP] dio rewrite
Message-ID: <20130212013315.GL12631@moria.home.lan>
References: <20130212005326.GA6592@moria.home.lan>
 <20130212012413.GA30387@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130212012413.GA30387@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 05:24:13PM -0800, Andi Kleen wrote:
> On Mon, Feb 11, 2013 at 04:53:26PM -0800, Kent Overstreet wrote:
> > I finally started hacking on the dio code, and it's far from done but
> > it's turning out better than I expected so I thought I'd show off what
> > I've got so far.
> 
> The critical metric for some of the highend workloads 
> is the number of cache lines touched in the submission path
> (especially potentially modified ones). How does your new code fare on that?

I haven't started looking at performance yet, except to sanity check it
- but it should be substantially better, mostly due to getting rid of
dio->pages.

As far as touching shared cachelines I don't think it's any different
than the old code, though.

There's also icache, which should be hugely better.

But the code's changed so much I'll have to spend some time optimizing
it before I can make a reasonable comparison, after I've finished with
all the correctness issues.
