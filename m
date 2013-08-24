Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755660Ab3HXUa7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Aug 2013 16:30:59 -0400
Received: from mout.gmx.net ([212.227.15.19]:53180 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755521Ab3HXUa6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Aug 2013 16:30:58 -0400
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="utf-8"
Date: Sat, 24 Aug 2013 22:30:55 +0200
From: "Tibor Billes" <tbilles@gmx.com>
Message-ID: <20130824203055.44750@gmx.com>
MIME-Version: 1.0
Subject: Re: Unusually high system CPU usage with recent kernels
To: paulmck@linux.vnet.ibm.com
X-Flags: 0001
X-Mailer: GMX.com Web Mailer
x-registered: 0
Content-Transfer-Encoding: 8bit
X-GMX-UID: qHJrch9weSEqJL5QQHchuAd+IGRvbwAC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Paul E. McKenney Sent: 08/24/13 02:18 AM
> On Fri, Aug 23, 2013 at 03:20:25PM +0200, Tibor Billes wrote:
> > > From: Paul E. McKenney Sent: 08/22/13 12:09 AM
> > > On Wed, Aug 21, 2013 at 11:05:51PM +0200, Tibor Billes wrote:
> > > > > From: Paul E. McKenney Sent: 08/21/13 09:12 PM
> > > > > On Wed, Aug 21, 2013 at 08:14:46PM +0200, Tibor Billes wrote:
> > > > > > > From: Paul E. McKenney Sent: 08/20/13 11:43 PM
> > > > > > > On Tue, Aug 20, 2013 at 10:52:26PM +0200, Tibor Billes wrote:
> > > > > > > > > From: Paul E. McKenney Sent: 08/20/13 04:53 PM
> > > > > > > > > On Tue, Aug 20, 2013 at 08:01:28AM +0200, Tibor Billes wrote:
> > > > > > > > > > Hi,
> > > > > > > > > > 
> > > > > > > > > > I was using the 3.9.7 stable release and tried to upgrade to the 3.10.x series.
> > > > > > > > > > The 3.10.x series was showing unusually high (>75%) system CPU usage in some
> > > > > > > > > > situations, making things really slow. The latest stable I tried is 3.10.7.
> > > > > > > > > > I also tried 3.11-rc5, they both show this behaviour. This behaviour doesn't
> > > > > > > > > > show up when the system is idling, only when doing some CPU intensive work,
> > > > > > > > > > like compiling with multiple threads. Compiling with only one thread seems not
> > > > > > > > > > to trigger this behaviour.
> > > > > > > > > > 
> > > > > > > > > > To be more precise I did a `perf record -a` while compiling a large C++ program
> > > > > > > > > > with scons using 4 threads, the result is appended at the end of this email.
> > > > > > > > > 
> > > > > > > > > New one on me! You are running a mainstream system (x86_64), so I am
> > > > > > > > > surprised no one else noticed.
> > > > > > > > > 
> > > > > > > > > Could you please send along your .config file?
> > > > > > > > 
> > > > > > > > Here it is
> > > > > > > 
> > > > > > > Interesting. I don't see RCU stuff all that high on the list, but
> > > > > > > the items I do see lead me to suspect RCU_FAST_NO_HZ, which has some
> > > > > > > relevance to the otherwise inexplicable group of commits you located
> > > > > > > with your bisection. Could you please rerun with CONFIG_RCU_FAST_NO_HZ=n?
> > > > > > > 
> > > > > > > If that helps, there are some things I could try.
> > > > > > 
> > > > > > It did help. I didn't notice anything unusual when running with CONFIG_RCU_FAST_NO_HZ=n.
> > > > > 
> > > > > Interesting. Thank you for trying this -- and we at least have a
> > > > > short-term workaround for this problem. I will put a patch together
> > > > > for further investigation.
> > > > 
> > > > I don't specifically need this config option so I'm fine without it in
> > > > the long term, but I guess it's not supposed to behave like that.
> > > 
> > > OK, good, we have a long-term workload for your specific case,
> > > even better. ;-)
> > > 
> > > But yes, there are situations where RCU_FAST_NO_HZ needs to work
> > > a bit better. I hope you will bear with me with a bit more
> > > testing...
> > 
> > Don't worry, I will :) Unfortunately I didn't have time yesterday and I
> > won't have time today either. But I'll do what you asked tomorrow and I'll
> > send you the results.
> 
> Not a problem! I did find one issue that -might- help, please see
> the patch below. (Run with CONFIG_RCU_FAST_NO_HZ=y.)
> 
> Please let me know how it goes!

I applied the patch on top of 3.11-rc6, but it did not help, I'm still
hitting this issue.

Let me know if you have anything else that I can test!

Tibor
