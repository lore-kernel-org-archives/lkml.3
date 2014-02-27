Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752330AbaB0PYH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:24:07 -0500
Received: from moutng.kundenserver.de ([212.227.126.131]:57158 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192AbaB0PYF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:24:05 -0500
Message-ID: <1393514533.28343.19.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] rcu: move SRCU grace period work to power efficient
 workqueue
From: Mike Galbraith <bitbucket@online.de>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Kevin Hilman <khilman@linaro.org>, Tejun Heo <tj@kernel.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Zoran Markovic <zoran.markovic@linaro.org>,
        linux-kernel@vger.kernel.org,
        Shaibal Dutta <shaibal.dutta@broadcom.com>,
        Dipankar Sarma <dipankar@in.ibm.com>
Date: Thu, 27 Feb 2014 16:22:13 +0100
In-Reply-To: <20140227144331.GA19580@localhost.localdomain>
References: <1391197986-12774-1-git-send-email-zoran.markovic@linaro.org>
	 <52F8A51F.4090909@cn.fujitsu.com>
	 <20140210184729.GL4250@linux.vnet.ibm.com>
	 <20140212182336.GD5496@localhost.localdomain>
	 <1392614801.5565.92.camel@marge.simpson.net>
	 <20140227144331.GA19580@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:1R1R0ffJUN2Xc944U8U4hJOJqGxSauoCnlYm00Webu/
 j8Zz1pIRjN4Omgpc/PaoU9DhQoLHLe+9wRl+p09o8zzraMtuhP
 VGQeD7aixxplo+e83cqnlXO7+LdLnDD4+uwJczHd1CrsR6Ng6K
 pXkb8Rv8VDl86rMCVL0a1YKTymlCSOQKlArT4qqnfqGUlOWPXq
 Vmy3gO0HAu0PRCu/FjN9J6uAXPuaB51k3ZsuxW5AalLWLLytun
 qG1Y7RdKLZp0wwkVLHKy+Wz4uB6IwSndLhXbN3m6eceez6CGEI
 PYyYuNA/xj1spkzozM5aJT1afLzpFkReYGFauPCs/b46cck1Ot
 DBiMltEy/Us8RBMwb0wgee55DO3/iYHCsLboTxdUP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-02-27 at 15:43 +0100, Frederic Weisbecker wrote: 
> On Mon, Feb 17, 2014 at 06:26:41AM +0100, Mike Galbraith wrote:
> > On Wed, 2014-02-12 at 19:23 +0100, Frederic Weisbecker wrote: 
> > > On Mon, Feb 10, 2014 at 10:47:29AM -0800, Paul E. McKenney wrote:
> > > > On Mon, Feb 10, 2014 at 06:08:31PM +0800, Lai Jiangshan wrote:
> > > > > Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> > > > 
> > > > Thank you all, queued for 3.15.
> > > > 
> > > > We should also have some facility for moving the SRCU workqueues to
> > > > housekeeping/timekeeping kthreads in the NO_HZ_FULL case.  Or does
> > > > this patch already have that effect?
> > > 
> > > Kevin Hilman and me plan to try to bring a new Kconfig option that could let
> > > us control the unbound workqueues affinity through sysfs.
> > 
> > Handing control to the user seemed like a fine thing, so I started
> > making a boot option to enable it.  Forcing WQ_SYSFS on at sysfs
> > decision spot doesn't go well, init order matters :)  Post init frobbing
> > required if you want to see/frob all unbound.
> 
> I'm curious about the details. Is that because some workqueues are registered
> before sysfs is even initialized?

Yeah.  I put in a test, and told it if not ready, go get ready and flag
yourself as having BTDT (one registration being plenty), but that only
made a different explosion.  Post-init rescan is definitely a better
plan, it can't be worse :)

-Mike

