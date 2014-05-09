Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937AbaEIPeP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 May 2014 11:34:15 -0400
Received: from qmta09.emeryville.ca.mail.comcast.net ([76.96.30.96]:37034 "EHLO
	qmta09.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756922AbaEIP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 May 2014 11:28:32 -0400
Date: Fri, 9 May 2014 10:28:27 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Thomas Gleixner <tglx@linutronix.de>
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
In-Reply-To: <alpine.DEB.2.02.1405091659350.6261@ionos.tec.linutronix.de>
Message-ID: <alpine.DEB.2.10.1405091027040.11318@gentwo.org>
References: <alpine.DEB.2.10.1405081033090.23786@gentwo.org> <20140508142903.c2ef166c95d2b8acd0d7ea7d@linux-foundation.org> <alpine.DEB.2.02.1405090003120.6261@ionos.tec.linutronix.de> <alpine.DEB.2.10.1405090949170.11318@gentwo.org>
 <alpine.DEB.2.02.1405091659350.6261@ionos.tec.linutronix.de>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 May 2014, Thomas Gleixner wrote:

> > Ok how do I figure out that cpu? I'd rather have a specific cpu that
> > never changes.
>
> I followed the full nohz development only losely, but back then when
> all started here at my place with frederic, we had a way to define the
> housekeeper cpu. I think we lazily had it hardwired to 0 :)

Yes that would be the easiest and simplest. We dedicate cpu 0 to OS
services around
here anyways.

> That probably changed, but I'm sure there is still a way to define a
> housekeeper. And we should simply force the timekeeping on that
> housekeeper. That comes with the price, that the housekeeper is not
> allowed to go deep idle, but I bet that in HPC scenarios this does not
> matter at all simply because the whole machine is under full load.

Excellent. Yes. Good.

> >
> > The vmstat kworker thread checks every 2 seconds if there are vmstat
> > updates that need to be folded into the global statistics. This is not
> > necessary if the application is running and no OS services are being used.
> > Thus we could switch off vmstat updates and avoid taking the processor
> > away from the application.
> >
> > This has also been noted by multiple other people at was brought up at the
> > mm summit by others who noted the same issues.
>
> I understand why you want to get this done by a housekeeper, I just
> did not understand why we need this whole move it around business is
> required.

This came about because of another objection against having it simply
fixed to a processor. After all that processor may be disabled etc etc.

