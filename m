Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758598Ab3BVUvt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:51:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46275 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757322Ab3BVUvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:51:48 -0500
Date: Fri, 22 Feb 2013 21:51:44 +0100
From: Jan Kara <jack@suse.cz>
To: Marcus Sundman <marcus@hibox.fi>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: Debugging system freezes on filesystem writes
Message-ID: <20130222205144.GA30600@quack.suse.cz>
References: <20121107161730.GB23654@quack.suse.cz>
 <509C4339.2090506@hibox.fi>
 <509D014B.2080709@hibox.fi>
 <20121113135159.GA18651@quack.suse.cz>
 <50A592BA.8050709@hibox.fi>
 <20121121233021.GA8730@quack.suse.cz>
 <50B4E6F2.6010000@hibox.fi>
 <20121205153216.GF5706@quack.suse.cz>
 <51248C5F.4040606@hibox.fi>
 <5124B613.6040400@hibox.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5124B613.6040400@hibox.fi>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 20-02-13 13:40:03, Marcus Sundman wrote:
> On 20.02.2013 10:42, Marcus Sundman wrote:
> >On 05.12.2012 17:32, Jan Kara wrote:
> >>   I see. Maybe you could have something like
> >>while true; do echo w >/proc/sysrq-trigger; sleep 10; done
> >>   running in the background?
> >
> >Sure, but I suspect it'll take until the worst is over before it
> >manages to load and execute that "echo w".
> 
> Here is a big run of sysrq-triggering, all while I was uncompressing
> a big rar file causing the whole system to be utterly unusable.
> NB: Even with realtime I/O-priority the sysrq couldn't be triggered
> between 12:41:54 and 12:42:49, as you can see from the dmesg-3.txt
> file.
> 
> $ sudo ionice -c 1 su
> # ionice
> realtime: prio 4
> # while true; do sleep 10; echo w >/proc/sysrq-trigger; done
> ^C
> # tail -n +1700 /var/log/syslog >dmesg-3.txt
> 
> http://sundman.iki.fi/dmesg-3.txt
  Thanks for the traces. I was looking at them and we seem to be always
waiting for IO. There don't seem to be that much CPU load either.

I'm actually starting to suspect the SSD in your laptop. The svctm field
from iostat output shows it takes 1 second on average to complete an IO
request. That is awfully slow given one request has ~180 KB of data on
average. Ah, one more idea - can you post your /proc/mounts please?

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
