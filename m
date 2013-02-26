Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758699Ab3BZXRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 18:17:09 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37614 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753728Ab3BZXRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 18:17:07 -0500
Date: Wed, 27 Feb 2013 00:17:03 +0100
From: Jan Kara <jack@suse.cz>
To: Marcus Sundman <marcus@hibox.fi>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Dave Chinner <david@fromorbit.com>,
        Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130226231703.GA22674@quack.suse.cz>
References: <20121121233021.GA8730@quack.suse.cz>
 <50B4E6F2.6010000@hibox.fi>
 <20121205153216.GF5706@quack.suse.cz>
 <51248C5F.4040606@hibox.fi>
 <5124B613.6040400@hibox.fi>
 <20130222205144.GA30600@quack.suse.cz>
 <5127FEEA.60207@hibox.fi>
 <20130224001222.GB5551@dastard>
 <20130224012052.GC1196@thunk.org>
 <512D01E0.7010009@hibox.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <512D01E0.7010009@hibox.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 26-02-13 20:41:36, Marcus Sundman wrote:
> On 24.02.2013 03:20, Theodore Ts'o wrote:
> >On Sun, Feb 24, 2013 at 11:12:22AM +1100, Dave Chinner wrote:
> >>>>/dev/sda6 /home ext4 rw,noatime,discard 0 0
> >>                                    ^^^^^^^
> >>I'd say that's your problem....
> >Looks like the Sandisk U100 is a good SSD for me to put on my personal
> >"avoid" list:
> >
> >http://thessdreview.com/our-reviews/asus-zenbook-ssd-review-not-necessarily-sandforce-driven-shows-significant-speed-bump/
> >
> >There are a number of SSD's which do not implement "trim" efficiently,
> >so these days, the recommended way to use trim is to run the "fstrim"
> >command out of crontab.
> 
> OK. Removing 'discard' made it much better (the 60-600 second
> freezes are now 1-50 second freezes), but it's still at least an
> order of magnitude worse than a normal HD. When writing, that is --
> reading is very fast (when there's no writing going on).
> 
> So, after reading up a bit on this trimming I'm thinking maybe my
> filesystem's block sizes don't match up with my SSD's blocks (or
> whatever its write unit is called). Then writing a FS block would
> always write to multiple SSD blocks, causing multiple
> read-erase-write sequences, right? So how can I check this, and how
> can I make the FS blocks match the SSD blocks?
  As Ted wrote, alignment isn't usually a problem with SSDs. And even if it
was, it would be at most a factor 2 slow down and we don't seem to be at
that fine grained level :)

At this point you might try mounting the fs with nobarrier mount option (I
know you tried that before but without discard the difference could be more
visible), switching IO scheduler to CFQ (for crappy SSDs it actually isn't
a bad choice), and we'll see how much we can squeeze out of your drive...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
