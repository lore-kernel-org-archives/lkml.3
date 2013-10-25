Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348Ab3JYXFy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 19:05:54 -0400
Received: from mga11.intel.com ([192.55.52.93]:15080 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364Ab3JYXFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 19:05:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,573,1378882800"; 
   d="scan'208";a="417377553"
Date: Sat, 26 Oct 2013 00:05:45 +0100
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Theodore Ts'o" <tytso@mit.edu>, "Artem S. Tashkinov" <t.artem@lycos.com>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Cc: Diego Calleja <diegocg@gmail.com>, David Lang <david@lang.hm>,
        NeilBrown <neilb@suse.de>
Subject: Re: Disabling in-memory write cache for x86-64 in Linux II
Message-ID: <20131025230545.GB31280@localhost>
References: <160824051.3072.1382685914055.JavaMail.mail@webmail07>
 <CA+55aFxj81TRhe1+FJWqER7VVH_z_Sk0+hwtHvniA0ATsF_eKw@mail.gmail.com>
 <1814253454.3449.1382689853825.JavaMail.mail@webmail07>
 <20131025091842.GA28681@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131025091842.GA28681@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 25, 2013 at 05:18:42AM -0400, Theodore Ts'o wrote:
> On Fri, Oct 25, 2013 at 08:30:53AM +0000, Artem S. Tashkinov wrote:
> > My feeling is that vm.dirty_ratio/vm.dirty_background_ratio should _not_ be
> > percentage based, 'cause for PCs/servers with a lot of memory (say 64GB or
> > more) this value becomes unrealistic (13GB) and I've already had some
> > unpleasant effects due to it.
> 
> What I think would make sense is to dynamically measure the speed of
> writeback, so that we can set these limits as a function of the device
> speed.  It's already the case that the writeback limits don't make
> sense on a slow USB 2.0 storage stick; I suspect that for really huge
> RAID arrays or very fast flash devices, it doesn't make much sense
> either.
> 
> The problem is that if you have a system that has *both* a USB stick
> _and_ a fast flash/RAID storage array both needing writeback, this
> doesn't work well --- but what we have right now doesn't work all that
> well anyway.

Ted, when trying to follow up your email, I got a crazy idea and it'd
be better throw it out rather than carrying it to bed. :)

We could do per-bdi dirty thresholds - which has been proposed 1-2
times before by different people.

The per-bdi dirty thresholds could be auto set by the kernel this way: 
start it with an initial value of 100MB. When reached, put all the
100MB dirty data to IO and get an estimation of the write bandwidth.
>From then on, set the bdi's dirty threshold to N * bdi_write_bandwidth,
where N is the seconds of dirty data we'd like to cache in memory.

Thanks,
Fengguang
