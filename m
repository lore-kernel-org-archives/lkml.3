Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab3BXBVG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 20:21:06 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:49618 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758968Ab3BXBVF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 20:21:05 -0500
Date: Sat, 23 Feb 2013 20:20:52 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Dave Chinner <david@fromorbit.com>
Cc: Marcus Sundman <marcus@hibox.fi>, Jan Kara <jack@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130224012052.GC1196@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Dave Chinner <david@fromorbit.com>,
	Marcus Sundman <marcus@hibox.fi>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org
References: <20121113135159.GA18651@quack.suse.cz>
 <50A592BA.8050709@hibox.fi>
 <20121121233021.GA8730@quack.suse.cz>
 <50B4E6F2.6010000@hibox.fi>
 <20121205153216.GF5706@quack.suse.cz>
 <51248C5F.4040606@hibox.fi>
 <5124B613.6040400@hibox.fi>
 <20130222205144.GA30600@quack.suse.cz>
 <5127FEEA.60207@hibox.fi>
 <20130224001222.GB5551@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130224001222.GB5551@dastard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 11:12:22AM +1100, Dave Chinner wrote:
> > >/dev/sda6 /home ext4 rw,noatime,discard 0 0
>                                    ^^^^^^^
> I'd say that's your problem....

Looks like the Sandisk U100 is a good SSD for me to put on my personal
"avoid" list:

http://thessdreview.com/our-reviews/asus-zenbook-ssd-review-not-necessarily-sandforce-driven-shows-significant-speed-bump/

There are a number of SSD's which do not implement "trim" efficiently,
so these days, the recommended way to use trim is to run the "fstrim"
command out of crontab.

There are some high performance flash devices (especially PCIe
attached flash devices, where the TRIM command doesn't necessarily
mean waiting for the entire contents of the Native Command Queue to
drain) where using the discard mount option makes sense for best
performance, but for most SATA drives (especially the really
cheap-sh*t ones), I don't recommend it.  If it weren't for the fact
that for these devices exist and the discard option is especially
useful for them, I probably would have removed the discard option from
ext4.

						- Ted
