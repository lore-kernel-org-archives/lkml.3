Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab3ENGet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 02:34:49 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:21576 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751387Ab3ENGer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 02:34:47 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AswPAJ3ZkVF5LCz9/2dsb2JhbABagweDCrg1hSQEAYEGF3SCHwEBBTocGQoQCAMYCSUPBSUDIRMYh3OuGY8SFo1sgR0HgnRhA5cukTmDISo
Date: Tue, 14 May 2013 16:34:38 +1000
From: Dave Chinner <david@fromorbit.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Daniel Phillips <daniel.raymond.phillips@gmail.com>,
        linux-fsdevel@vger.kernel.org, tux3@tux3.org,
        linux-kernel@vger.kernel.org
Subject: Re: Tux3 Report: Faster than tmpfs, what?
Message-ID: <20130514063438.GF29466@dastard>
References: <CAEsagEhu3pND5j410mQM=AMEQZ-1WOG0qdKys0pfFv0-jkLs8g@mail.gmail.com>
 <20130510045049.GU24635@dastard>
 <87fvxvz8qw.fsf@devron.myhome.or.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87fvxvz8qw.fsf@devron.myhome.or.jp>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 10, 2013 at 02:47:35PM +0900, OGAWA Hirofumi wrote:
> Dave Chinner <david@fromorbit.com> writes:
> 
> >> tux3:
> >>     Operation      Count    AvgLat    MaxLat
> >>     ----------------------------------------
> >>     NTCreateX    1477980     0.003    12.944
> > ....
> >>     ReadX        2316653     0.002     0.499
> >>     LockX           4812     0.002     0.207
> >>     UnlockX         4812     0.001     0.221
> >>     Throughput 1546.81 MB/sec  1 clients  1 procs  max_latency=12.950 ms
> >
> > Hmmm... No "Flush" operations. Gotcha - you've removed the data
> > integrity operations from the benchmark.
> 
> Right. Because tux3 is not implementing fsync() yet. So, I did
> 
> 	grep -v Flush /usr/share/dbench/client.txt > client2.txt
> 
> Why is it important for comparing?

Because nobody could reproduce your results without working that
out. You didn't disclose that you'd made these changes, and that
makes it extremely misleading as to what the results mean. Given the
headline-grab nature of it, it's deceptive at best.

I don't care how fast tux3 is - I care about being able to reproduce
other people's results. Hence if you are going to report benchmark
results comparing filesystems then you need to tell everyone exactly
what you've tweaked and why, from the hardware all the way up to the
benchmark config.

Work on how *you* report *your* results - don't let Daniel turn them
into some silly marketing fluff that tries to grab headlines.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
