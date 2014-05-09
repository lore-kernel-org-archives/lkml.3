Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378AbaEIPFP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:05:15 -0400
Received: from www.linutronix.de ([62.245.132.108]:36928 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751067AbaEIPFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:05:12 -0400
Date: Fri, 9 May 2014 17:05:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Christoph Lameter <cl@linux.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, hughd@google.com,
        viresh.kumar@linaro.org
Subject: Re: vmstat: On demand vmstat workers V4
In-Reply-To: <alpine.DEB.2.10.1405090949170.11318@gentwo.org>
Message-ID: <alpine.DEB.2.02.1405091659350.6261@ionos.tec.linutronix.de>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org> <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org> <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405090949170.11318@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Christoph Lameter wrote:
> On Fri, 9 May 2014, Thomas Gleixner wrote:
> > I think we agreed long ago, that for the whole HPC FULL_NOHZ stuff you
> > have to sacrify at least one CPU for housekeeping purposes of all
> > kinds, timekeeping, statistics and whatever.
> 
> Ok how do I figure out that cpu? I'd rather have a specific cpu that
> never changes.

I followed the full nohz development only losely, but back then when
all started here at my place with frederic, we had a way to define the
housekeeper cpu. I think we lazily had it hardwired to 0 :)

That probably changed, but I'm sure there is still a way to define a
housekeeper. And we should simply force the timekeeping on that
housekeeper. That comes with the price, that the housekeeper is not
allowed to go deep idle, but I bet that in HPC scenarios this does not
matter at all simply because the whole machine is under full load.

Frederic?

> > So if you have a housekeeper, then it makes absolutely no sense at all
> > to move it around in circles.
> >
> > Can you please enlighten me why we need this at all?
> 
> The vmstat kworker thread checks every 2 seconds if there are vmstat
> updates that need to be folded into the global statistics. This is not
> necessary if the application is running and no OS services are being used.
> Thus we could switch off vmstat updates and avoid taking the processor
> away from the application.
> 
> This has also been noted by multiple other people at was brought up at the
> mm summit by others who noted the same issues.

I understand why you want to get this done by a housekeeper, I just
did not understand why we need this whole move it around business is
required.
 
Thanks,

	tglx

