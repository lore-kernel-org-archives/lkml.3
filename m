Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186Ab3JYXiH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:38:07 -0400
Received: from imap.thunk.org ([74.207.234.97]:50878 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751514Ab3JYXiF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:38:05 -0400
Date: Fri, 25 Oct 2013 19:37:53 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Artem S. Tashkinov" <t.artem@lycos.com>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Diego Calleja <diegocg@gmail.com>, David Lang <david@lang.hm>,
        NeilBrown <neilb@suse.de>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131025233753.GD19823@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Fengguang Wu <fengguang.wu@intel.com>,
	"Artem S. Tashkinov" <t.artem@lycos.com>,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, Diego Calleja <diegocg@gmail.com>,
	David Lang <david@lang.hm>, NeilBrown <neilb@suse.de>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
 <20131025230545.GB31280@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025230545.GB31280@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 26, 2013 at 12:05:45AM +0100, Fengguang Wu wrote:
> 
> Ted, when trying to follow up your email, I got a crazy idea and it'd
> be better throw it out rather than carrying it to bed. :)
> 
> We could do per-bdi dirty thresholds - which has been proposed 1-2
> times before by different people.
> 
> The per-bdi dirty thresholds could be auto set by the kernel this way: 
> start it with an initial value of 100MB. When reached, put all the
> 100MB dirty data to IO and get an estimation of the write bandwidth.
> From then on, set the bdi's dirty threshold to N * bdi_write_bandwidth,
> where N is the seconds of dirty data we'd like to cache in memory.

Sure, although I wonder if it would be worth it calcuate some kind of
rolling average of the write bandwidth while we are doing writeback,
so if it turns out we got unlucky with the contents of the first 100MB
of dirty data (it could be either highly random or highly sequential)
the we'll eventually correct to the right level.

This means that VM would have to keep dirty page counters for each BDI
--- which I thought we weren't doing right now, which is why we have a
global vm.dirty_ratio/vm.dirty_background_ratio threshold.  (Or do I
have cause and effect reversed?  :-)

						- Ted
