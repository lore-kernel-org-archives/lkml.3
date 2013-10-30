Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3J3PMb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 11:12:31 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54917 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3J3PMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 11:12:30 -0400
Date: Wed, 30 Oct 2013 16:12:25 +0100
From: Jan Kara <jack@suse.cz>
To: "Artem S. Tashkinov" <t.artem@lycos.com>
Cc: jack@suse.cz, tytso@mit.edu, fengguang.wu@intel.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, diegocg@gmail.com, david@lang.hm,
        neilb@suse.de
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131030151225.GA15202@quack.suse.cz>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025230545.GB31280@localhost>
 <20131025233753.GD19823@thunk.org>
 <20131029204052.GF9568@quack.suse.cz>
 <1532891663.73423.1383127628582.JavaMail.mail@webmail14>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1532891663.73423.1383127628582.JavaMail.mail@webmail14>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 30-10-13 10:07:08, Artem S. Tashkinov wrote:
> Oct 30, 2013 02:41:01 AM, Jack wrote:
> On Fri 25-10-13 19:37:53, Ted Tso wrote:
> >> Sure, although I wonder if it would be worth it calcuate some kind of
> >> rolling average of the write bandwidth while we are doing writeback,
> >> so if it turns out we got unlucky with the contents of the first 100MB
> >> of dirty data (it could be either highly random or highly sequential)
> >> the we'll eventually correct to the right level.
> >  We already do average measured throughput over a longer time window and
> >have kind of rolling average algorithm doing some averaging.
> >
> >> This means that VM would have to keep dirty page counters for each BDI
> >> --- which I thought we weren't doing right now, which is why we have a
> >> global vm.dirty_ratio/vm.dirty_background_ratio threshold.  (Or do I
> >> have cause and effect reversed?  :-)
> >  And we do currently keep the number of dirty & under writeback pages per
> >BDI. We have global limits because mm wants to limit the total number of dirty
> >pages (as those are harder to free). It doesn't care as much to which device
> >these pages belong (although it probably should care a bit more because
> >there are huge differences between how quickly can different devices get rid
> >of dirty pages).
> 
> This might sound like an absolutely stupid question which makes no sense at
> all, so I want to apologize for it in advance, but since the Linux kernel lacks
> revoke(), does that mean that dirty buffers will always occupy the kernel memory
> if I for instance remove my USB stick before the kernel has had the time to flush
> these buffers?
  That's actually a good question. And the answer is that currently when we
hit EIO while writing out dirty data, we just throw away that data. Not
an ideal solution for some cases but it solves the problem with unwriteable
data...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
