Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3DKTSf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 15:18:35 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37364 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751003Ab3DKTSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 15:18:33 -0400
Date: Thu, 11 Apr 2013 12:17:14 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Christoph Lameter <cl@linux.com>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@linaro.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 4/4] nohz: New option to force all CPUs in full dynticks
 range
Message-ID: <20130411191714.GQ29861@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAFTL4hzQfodVP4O+nir1XwQ2QkUUqrfr_dBpWL0635f0u4oRBA@mail.gmail.com>
 <20130330091037.GA31743@gmail.com>
 <0000013dea26b171-8095c339-dc81-4459-a3ad-a8d69c803448-000000@email.amazonses.com>
 <20130411151956.GF15699@somewhere>
 <20130411153721.GA3742@linux.vnet.ibm.com>
 <20130411155349.GA16797@somewhere.redhat.com>
 <0000013df9f8d526-2783fba3-4dc9-44c6-8b02-2c321eb5b37b-000000@email.amazonses.com>
 <20130411170420.GA17129@somewhere.redhat.com>
 <20130411171153.GG29861@linux.vnet.ibm.com>
 <20130411172803.GC17129@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130411172803.GC17129@somewhere.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13041119-9360-0000-0000-000011B3F151
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 07:28:05PM +0200, Frederic Weisbecker wrote:
> On Thu, Apr 11, 2013 at 10:11:53AM -0700, Paul E. McKenney wrote:
> > On Thu, Apr 11, 2013 at 07:04:23PM +0200, Frederic Weisbecker wrote:
> > > On Thu, Apr 11, 2013 at 04:41:07PM +0000, Christoph Lameter wrote:
> > > > On Thu, 11 Apr 2013, Frederic Weisbecker wrote:
> > > > 
> > > > > If there is no performance issue with that I'm all for it.
> > > > 
> > > > Or have a
> > > > 
> > > > CONFIG_LOWLATENCY
> > > > 
> > > > that boots up a kernel with the proper configuration?
> > > 
> > > It may be too general for a naming. But I don't mind just
> > > selecting CONFIG_RCU_NOCBS_ALL unconditionally. It's easily
> > > changed in the future if anybody complains.
> > > 
> > > Btw, if CONFIG_RCU_NOCBS_ALL is set, the rcu_nocbs= parameter
> > > is ignored, right? If you want to keep that direction and not
> > > override the Kconfig choice, may be warn the user about that
> > > if the boot parameter is passed?
> > 
> > Fair point.  Let me think about how I should approach Thanx.
> 
> An alternative is to treat the Kconfig choice as a default setting
> that gets overriden by rcu_nocbs=
> 
> This would require to refactor the three way Kconfig layout you've set,
> but that aligns with what Ingo is suggesting me to do with the full dynticks
> range: having CONFIG_NO_HZ_EXTENDED_ALL that is overriden by nohz_extended=
> if any (beware though, "extended" will soon be renamed to "full", lets hope
> it's our last take ;)

So the idea is that if CONFIG_NO_HZ_EXTENDED_ALL is specified, the list
passed via nohz_extended= is ANDed rather than ORed?  Interesting...

> That unifies both behaviours and it looks more flexible to me.
> 
> Of course that means selecting CONFIG_RCU_NOCBS_ALL won't be enough for
> me to ensure my nohz range is also nocb, I'm fine with the cpumask check
> on boot though.
> 
> Anyway, that's just a suggestion, the most important is that the
> user is informed of what's happening and how to deal with it.

I will hold off a bit and see how things settle out.

							Thanx, Paul

