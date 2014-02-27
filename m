Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752919AbaB0Onl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 09:43:41 -0500
Received: from mail-wg0-f52.google.com ([74.125.82.52]:59991 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbaB0Onj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 09:43:39 -0500
Date: Thu, 27 Feb 2014 15:43:35 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mike Galbraith <bitbucket@online.de>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
Message-ID: <20140227144331.GA19580@localhost.localdomain>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
 <52F8A51F.4090909@cn.fujitsu.com>
 <20140210184729.GL4250@linux.vnet.ibm.com>
 <20140212182336.GD5496@localhost.localdomain>
 <1392614801.5565.92.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392614801.5565.92.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 17, 2014 at 06:26:41AM +0100, Mike Galbraith wrote:
> On Wed, 2014-02-12 at 19:23 +0100, Frederic Weisbecker wrote: 
> > On Mon, Feb 10, 2014 at 10:47:29AM -0800, Paul E. McKenney wrote:
> > > On Mon, Feb 10, 2014 at 06:08:31PM +0800, Lai Jiangshan wrote:
> > > > Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > 
> > > Thank you all, queued for 3.15.
> > > 
> > > We should also have some facility for moving the SRCU workqueues to
> > > housekeeping/timekeeping kthreads in the NO_HZ_FULL case.  Or does
> > > this patch already have that effect?
> > 
> > Kevin Hilman and me plan to try to bring a new Kconfig option that could let
> > us control the unbound workqueues affinity through sysfs.
> 
> Handing control to the user seemed like a fine thing, so I started
> making a boot option to enable it.  Forcing WQ_SYSFS on at sysfs
> decision spot doesn't go well, init order matters :)  Post init frobbing
> required if you want to see/frob all unbound.

I'm curious about the details. Is that because some workqueues are registered
before sysfs is even initialized?
