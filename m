Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752336Ab3HUTMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 15:12:40 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:44996 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751696Ab3HUTMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 15:12:38 -0400
Date: Wed, 21 Aug 2013 12:12:33 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tibor Billes <tbilles@gmx.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Unusually high system CPU usage with recent kernels
Message-ID: <20130821191233.GY29406@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130821181446.168690@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130821181446.168690@gmx.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082119-5806-0000-0000-00002280D50D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 21, 2013 at 08:14:46PM +0200, Tibor Billes wrote:
> > From: Paul E. McKenney Sent: 08/20/13 11:43 PM
> > On Tue, Aug 20, 2013 at 10:52:26PM +0200, Tibor Billes wrote:
> > > > From: Paul E. McKenney Sent: 08/20/13 04:53 PM
> > > > On Tue, Aug 20, 2013 at 08:01:28AM +0200, Tibor Billes wrote:
> > > > > Hi,
> > > > > 
> > > > > I was using the 3.9.7 stable release and tried to upgrade to the 3.10.x series.
> > > > > The 3.10.x series was showing unusually high (>75%) system CPU usage in some
> > > > > situations, making things really slow. The latest stable I tried is 3.10.7.
> > > > > I also tried 3.11-rc5, they both show this behaviour. This behaviour doesn't
> > > > > show up when the system is idling, only when doing some CPU intensive work,
> > > > > like compiling with multiple threads. Compiling with only one thread seems not
> > > > > to trigger this behaviour.
> > > > > 
> > > > > To be more precise I did a `perf record -a` while compiling a large C++ program
> > > > > with scons using 4 threads, the result is appended at the end of this email.
> > > > 
> > > > New one on me! You are running a mainstream system (x86_64), so I am
> > > > surprised no one else noticed.
> > > > 
> > > > Could you please send along your .config file?
> > > 
> > > Here it is
> > 
> > Interesting. I don't see RCU stuff all that high on the list, but
> > the items I do see lead me to suspect RCU_FAST_NO_HZ, which has some
> > relevance to the otherwise inexplicable group of commits you located
> > with your bisection. Could you please rerun with CONFIG_RCU_FAST_NO_HZ=n?
> > 
> > If that helps, there are some things I could try.
> 
> It did help. I didn't notice anything unusual when running with CONFIG_RCU_FAST_NO_HZ=n.

Interesting.  Thank you for trying this -- and we at least have a
short-term workaround for this problem.  I will put a patch together
for further investigation.

In the meantime, could you please tell me how you were measuring
performance for your kernel builds?  Wall-clock time required to complete
one build?  Number of builds completed per unit time?  Something else?

							Thanx, Paul

