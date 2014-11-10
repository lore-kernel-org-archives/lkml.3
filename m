Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752445AbaKJQBJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 11:01:09 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:39866 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751726AbaKJQBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 11:01:08 -0500
Date: Mon, 10 Nov 2014 07:31:47 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Christoph Lameter <cl@linux.com>, Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>, Tejun Heo <tj@kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qti.qualcomm.com>,
        Hugh Dickins <hughd@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [NOHZ] Remove scheduler_tick_max_deferment
Message-ID: <20141110153147.GK4901@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <alpine.DEB.2.11.1410311058500.32582@gentwo.org>
 <alpine.DEB.2.11.1411012003390.5308@nanos>
 <alpine.DEB.2.11.1411011646280.7732@gentwo.org>
 <alpine.DEB.2.11.1411012313320.5308@nanos>
 <alpine.DEB.2.11.1411061057470.5591@gentwo.org>
 <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohpokE8pQUwTuMbnooAd3TsTgmrQWP4RtoJdwhJ5zps+O2zA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14111016-0033-0000-0000-000002A04C13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:41:38PM +0530, Viresh Kumar wrote:
> On 6 November 2014 22:54, Christoph Lameter <cl@linux.com> wrote:
> 
> > We did not need to housekeeper in the dynticks idle case. What is so
> > different about dynticks busy?
> 
> We do have a running task here and so the stats are important..
> 
> > I may not have the complete picture of the timer tick processing in my
> > mind these days (it has been a lots of years since I did any work there
> > after all) but as far as my arguably simplistic reading of the code goes I
> > do not see why a housekeeper would be needed there. The load is constant
> > and known in the dynticks busy case as it is in the dynticks idle case.
> 
> I tried to initiate a thread on similar stuff, might be helpful:
> 
> https://lkml.org/lkml/2014/5/22/131

Would it make sense for unlimited max deferment to be available as
a boot parameter?  That would allow people who want tick-free execution
more than accurate stats to get that easily, while keeping stats accurate
for everyone else.

							Thanx, Paul

