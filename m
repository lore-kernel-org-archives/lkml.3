Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752635Ab3J2UlD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:41:03 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49893 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751615Ab3J2UlA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:41:00 -0400
Date: Tue, 29 Oct 2013 21:40:52 +0100
From: Jan Kara <jack@suse.cz>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Diego Calleja <diegocg@gmail.com>,
        David Lang <david@lang.hm>, NeilBrown <neilb@suse.de>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131029204052.GF9568@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025230545.GB31280@localhost>
 <20131025233753.GD19823@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025233753.GD19823@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 25-10-13 19:37:53, Ted Tso wrote:
> On Sat, Oct 26, 2013 at 12:05:45AM +0100, Fengguang Wu wrote:
> > 
> > Ted, when trying to follow up your email, I got a crazy idea and it'd
> > be better throw it out rather than carrying it to bed. :)
> > 
> > We could do per-bdi dirty thresholds - which has been proposed 1-2
> > times before by different people.
> > 
> > The per-bdi dirty thresholds could be auto set by the kernel this way: 
> > start it with an initial value of 100MB. When reached, put all the
> > 100MB dirty data to IO and get an estimation of the write bandwidth.
> > From then on, set the bdi's dirty threshold to N * bdi_write_bandwidth,
> > where N is the seconds of dirty data we'd like to cache in memory.
> 
> Sure, although I wonder if it would be worth it calcuate some kind of
> rolling average of the write bandwidth while we are doing writeback,
> so if it turns out we got unlucky with the contents of the first 100MB
> of dirty data (it could be either highly random or highly sequential)
> the we'll eventually correct to the right level.
  We already do average measured throughput over a longer time window and
have kind of rolling average algorithm doing some averaging.

> This means that VM would have to keep dirty page counters for each BDI
> --- which I thought we weren't doing right now, which is why we have a
> global vm.dirty_ratio/vm.dirty_background_ratio threshold.  (Or do I
> have cause and effect reversed?  :-)
  And we do currently keep the number of dirty & under writeback pages per
BDI. We have global limits because mm wants to limit the total number of dirty
pages (as those are harder to free). It doesn't care as much to which device
these pages belong (although it probably should care a bit more because
there are huge differences between how quickly can different devices get rid
of dirty pages).

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
