Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752582Ab3CAVxy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 16:53:54 -0500
Received: from e39.co.us.ibm.com ([32.97.110.160]:43317 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3CAVxx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 16:53:53 -0500
Date: Fri, 1 Mar 2013 13:53:46 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Jan Kara <jack@suse.cz>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] printk: Avoid softlockups in console_unlock()
Message-ID: <20130301215346.GF3285@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1361927819-1570-1-git-send-email-jack@suse.cz>
 <20130227175945.GC3336@linux.vnet.ibm.com>
 <20130301103027.GC26128@quack.suse.cz>
 <20130301134321.85e18987.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130301134321.85e18987.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13030121-3620-0000-0000-0000016EFAD3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 01, 2013 at 01:43:21PM -0800, Andrew Morton wrote:
> On Fri, 1 Mar 2013 11:30:27 +0100
> Jan Kara <jack@suse.cz> wrote:
> 
> > > If a CPU remains in your loop where you invoke rcu_cpu_stall_reset(),
> > > there is no indication of the stall.  Now, I do understand why having
> > > RCU add a CPU stall warning into the mix would be very bad, but it
> > > would be good to have some sort of indication that there is stalling.
> > > Perhaps a counter visible in sysfs?  Whatever it is, at least some way
> > > of diagnosing the stall condition would be very good.
> >   I see. If others (Andrew, ping?) are OK with the rest of the patch, I can
> > extend it and add a counter of printk() breaks we had to make. That looks
> > like a good idea.
> 
> hmpf, spose so.  It sound lke the world's least interesting counter but
> perhaps it will look more interesting when we see its sparkly
> documentation.

Boredom is a good thing here, given that the goal is to reduce
excitement when bad things happen.  Or at least to increase awareness
of root causes.

							Thanx, Paul

