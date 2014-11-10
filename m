Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbaKJQTp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:19:45 -0500
Received: from resqmta-ch2-06v.sys.comcast.net ([69.252.207.38]:56456 "EHLO
	resqmta-ch2-06v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753788AbaKJQTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:19:43 -0500
Date: Mon, 10 Nov 2014 10:19:39 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Viresh Kumar <viresh.kumar@linaro.org>
cc: Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
In-Reply-To: <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
Message-ID: <alpine.DEB.2.11.1411100959390.6094@gentwo.org>
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org> <alpine.DEB.2.11.1411012003390.5308@nanos> <alpine.DEB.2.11.1411011646280.7732@gentwo.org> <alpine.DEB.2.11.1411012313320.5308@nanos> <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Nov 2014, Viresh Kumar wrote:

> On 6 November 2014 22:54, Christoph Lameter <cl@linux.com> wrote:
>
> > We did not need to housekeeper in the dynticks idle case. What is so
> > different about dynticks busy?
>
> We do have a running task here and so the stats are important..

The task is running in user space only and if there is any important
kernel action the tick will be coming on. Stats are not that important and
predictable I would say.

We could add stuff to the vmstat kworker thread to check for activity that
requires updates.

> > I may not have the complete picture of the timer tick processing in my
> > mind these days (it has been a lots of years since I did any work there
> > after all) but as far as my arguably simplistic reading of the code goes I
> > do not see why a housekeeper would be needed there. The load is constant
> > and known in the dynticks busy case as it is in the dynticks idle case.
>
> I tried to initiate a thread on similar stuff, might be helpful:
>
> https://lkml.org/lkml/2014/5/22/131

Hmmm... yes that is interesting. I agree that the process should be
exempted from load balancing since the idea of NOHZ is to lower OS noise
and load balancing would add significant amounts of noise.

NUMA balancing is also a source of noise and so we should have that off by
default as well.

