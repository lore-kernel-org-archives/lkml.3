Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756827Ab3ILUqv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 16:46:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55214 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755242Ab3ILUqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 16:46:50 -0400
Date: Thu, 12 Sep 2013 22:46:47 +0200
From: Jan Kara <jack@suse.cz>
To: Marcus Sundman <marcus@hibox.fi>
Cc: Jan Kara <jack@suse.cz>, "Theodore Ts'o" <tytso@mit.edu>,
        Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130912204647.GA6826@quack.suse.cz>
References: <20130224012052.GC1196@thunk.org>
 <512D01E0.7010009@hibox.fi>
 <20130226231703.GA22674@quack.suse.cz>
 <5231BA3C.2090704@hibox.fi>
 <20130912131051.GA14664@quack.suse.cz>
 <5231C5FF.3060504@hibox.fi>
 <20130912143941.GB14664@quack.suse.cz>
 <5231D8DD.5010703@hibox.fi>
 <20130912163530.GD14664@quack.suse.cz>
 <523200EB.7000202@hibox.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523200EB.7000202@hibox.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 12-09-13 20:59:07, Marcus Sundman wrote:
> On 12.09.2013 19:35, Jan Kara wrote:
> >On Thu 12-09-13 18:08:13, Marcus Sundman wrote:
> >>And can I somehow "reset" whatever it is that is making it worse so
> >>that it becomes good again? That way I could spend maybe 1 hour once
> >>every few months to get it back to top speed.
> >>Any other ideas how I could make this (very expensive and fairly new
> >>ZenBook) laptop usable?
> >   Well, I believe if you used like 70% or less of the disk and regularly
> >(like once in a few days) run fstrim command, I belive the disk performance
> >should stay at a usable level.
> 
> At 128 GB it is extremely small as it is, and I'm really struggling
> to fit all on it. Most of my stuff is on my NAS (which has almost 10
> TB space), but still I need several code repositories and the
> development environment and a virtual machine etc on this tiny 128
> GB thing.
  I see. I have like 70 GB disk and 50% of it are free :) But I have test
machines with much larger drives where I have VMs etc. This one is just
for email and coding.

> So, if I used some other filesystem, might that allow me to use a
> larger portion of the SSD without this degradation? Or with a much
> slower rate of degradation?
  You might try f2fs. That is designed for low end flash storage so it
might work better than ext4. But it is a new filesystem so backup often.

> And at some point it will become unusable again, so what can I do
> then? If I move everything to my NAS (and maybe even re-create the
> filesystem?) and move everything back, might that get rid of the FTL
> fragmentation?
  Yes, that should get rid of it. But since you have only a few GB free,
I'm afraid the fragmentation will reappear pretty quickly. But I guess it's
worth a try.

> Or could I somehow defragment the FTL without moving away everything?
  I don't know about such way.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
