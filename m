Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756293Ab3INClS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 22:41:18 -0400
Received: from imap.thunk.org ([74.207.234.97]:59968 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755938Ab3INClR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 22:41:17 -0400
Date: Fri, 13 Sep 2013 22:41:08 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Marcus Sundman <marcus@hibox.fi>
Cc: Jan Kara <jack@suse.cz>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130914024108.GA10740@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Marcus Sundman <marcus@hibox.fi>, Jan Kara <jack@suse.cz>,
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org
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
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 08:59:07PM +0300, Marcus Sundman wrote:
> 
> At 128 GB it is extremely small as it is, and I'm really struggling
> to fit all on it. Most of my stuff is on my NAS (which has almost 10
> TB space), but still I need several code repositories and the
> development environment and a virtual machine etc on this tiny 128
> GB thing.
> 
> So, if I used some other filesystem, might that allow me to use a
> larger portion of the SSD without this degradation? Or with a much
> slower rate of degradation?

What model are you using?  It's possible that your flash device was
designed as a cache driver for windows.  As such, it might have been
optimized for a read-mostly workload and not something for a lot of
random small writes.

The f2fs file system is designed for crappy flash drives with crappy
FTL's, so it might work be better for you.  But let me ask you this
--- how much is your data worth?  How much would it cost to replace
your flash device with something better?

I tend to get very nervous with crappy storage devices, and it sounds
like your flash drive isn't a particularly good one.  I'd strongly
suggest doing regular backups, because when flash devices die, they
can die in extremely catastrphic ways.

Regards,

						- Ted
