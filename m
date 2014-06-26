Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751610AbaFZTpU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 15:45:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14348 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaFZTpS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 15:45:18 -0400
Date: Thu, 26 Jun 2014 21:43:44 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/1] rcu: uninline rcu_lock_acquire() and
	rcu_lock_release()
Message-ID: <20140626194344.GA23225@redhat.com>
References: <20140626170116.GA28558@redhat.com> <20140626170143.GA28565@redhat.com> <20140626173327.GA1001@redhat.com> <20140626183657.GA18550@redhat.com> <20140626192117.GW4603@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140626192117.GW4603@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26, Paul E. McKenney wrote:
>
> On Thu, Jun 26, 2014 at 08:36:57PM +0200, Oleg Nesterov wrote:
>
> > > +static void rcu_release_map(struct lockdep_map *map, unsigned long ip)
> > > +{
> > > +	rcu_lockdep_assert_watching();
> > > +	__rcu_lock_release(&map, ip);
> >
> > "map", not "&map". I fixed this before I sent v2, but apparently forgot to
> > -add before --amend.
> >
> > Sorry for noise.
>
> Not a problem!  Looks generally sane, but with a bit of adjustment
> still needed.
>
> I got some test failures on v2:
>
> o	Build breakage if built with CONFIG_DEBUG_LOCK_ALLOC=n.  I believe
> 	that the best way to fix this is to #ifdef out the bodies of
> 	__rcu_lock_acquire() and __rcu_lock_release(), but maybe you
> 	have something else in mind.

Damn ;) Will fix and send v4. Thanks.

> o	Lockdep splat as follows, which might well be due to the
> 	"&map" that you noted above:

Yes, this should be hopefully fixed. Note that

> 	[    0.000000] [ BUG: bad unlock balance detected! ]
> 	[    0.000000] 3.16.0-rc1+ #1 Not tainted
> 	[    0.000000] -------------------------------------
> 	[    0.000000] swapper/0 is trying to release lock (X?à<81>ÿÿÿÿ<97>^Sò<81>ÿÿÿÿX?à<81>ÿÿÿÿ{±ò<81>@B^O) at:

prints garbage.

> And a few other things noted below.

Yes, will, do.

Thanks!

Oleg.

