Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754353AbaJHFbC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 01:31:02 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:56742 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaJHFbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 01:31:00 -0400
Message-ID: <1412746255.5179.34.camel@marge.simpson.net>
Subject: Re: High latency while CPU is under full load
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Grozdan <neutrino8@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Wed, 08 Oct 2014 07:30:55 +0200
In-Reply-To: <CAFLt3pjkXgz9H9p=u-NATyf4C+8ybJ3fwLc=GXEjaabBZ8NF5g@mail.gmail.com>
References: <CAFLt3pjkXgz9H9p=u-NATyf4C+8ybJ3fwLc=GXEjaabBZ8NF5g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-10-07 at 21:28 +0200, Grozdan wrote: 
> Hi,
> 
> Basically, my problem is this:
> 
> I'm doing a lot of audio/video encoding on an AMD FX8350. The encoder
> process always runs at nice 10. Even so, my whole system feels very
> sluggish. Switching between different app windows and/or virtual
> desktops takes up usually 3-5 seconds giving the impression that there
> is not enough processing power. Browsing the web is also severely
> impacted.
> 
> I had to tune CFS in order to be (much) more responsive during an
> encoding session. This has worked out pretty well thus far, but it is
> my opinion that the user should *not* need to fiddle with buttons to
> make his system respond fluently even under high load. The below is
> what I had to do in order to get a snappy system during such load

You shouldn't have to do any CFS twiddling.

I kinda doubt it's the CPU scheduler, would be more inclined to suspect
mm/IO.  You could try the BFQ IO scheduler, that showed some promise on
my little box when doing hefty IO to my single speck of spinning rust.

If you want to try it, and can't find it, I can send you a quilt tarball
to plug into 3.16.4. 

> kernel.sched_nr_migrate = 64
> kernel.sched_latency_ns = 65000000
> kernel.sched_wakeup_granularity_ns = 100000

100us... that's a bad idea.

> kernel.sched_min_granularity_ns = 100000

As is that, you'll likely be better off un-twiddling knobs.

> kernel.sched_migration_cost_ns = 7000000
> 
> I have tried 3 different kernels, including one compiled myself, but
> the results are the same
> Kernels I tried were: 3.11.10, 3.12 and 3.16.4 (self-compiled)
> 
> My system specs are as follows
> 
> CPU: AMD FX-8350 @ 4GHz
> RAM: 16GB DDR1333
> GPU: NVIDIA GTX 560 with NV blob driver

Not that I think NV is to blame, but you should probably try reproducing
the interactivity problem without that binary blob.  It's suspect just
for being a proprietary black hole, the perfect target to blame for all
your open source kernel woes ;-)

What are you encoding with what tools?  What does vmstat 1 look like
while box is working hard?  (With stock scheduler knobs I mean, and just
a few seconds)  Posting something easily reproducible (do this with that
tool) may help too.

-Mike

