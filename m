Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932359AbaEPTAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 15:00:47 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:39083 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932112AbaEPTAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 15:00:45 -0400
Date: Fri, 16 May 2014 15:00:42 -0400
From: Tejun Heo <tj@kernel.org>
To: Christoph Lameter <cl@linux.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/5] workqueue: Create low-level unbound workqueues
 cpumask
Message-ID: <20140516190042.GJ5379@htj.dyndns.org>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <1400257015-28222-4-git-send-email-fweisbec@gmail.com>
 <alpine.DEB.2.10.1405161250350.492@gentwo.org>
 <20140516183500.GI5379@htj.dyndns.org>
 <alpine.DEB.2.10.1405161350360.1681@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1405161350360.1681@gentwo.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 01:52:48PM -0500, Christoph Lameter wrote:
> On Fri, 16 May 2014, Tejun Heo wrote:
> 
> > On Fri, May 16, 2014 at 12:52:26PM -0500, Christoph Lameter wrote:
> > > On Fri, 16 May 2014, Frederic Weisbecker wrote:
> > >
> > > > It works on a lower-level than the per WQ_SYSFS workqueues cpumask files
> > > > such that the effective cpumask applied for a given unbound workqueue is
> > > > the intersection of /sys/devices/virtual/workqueue/$WORKQUEUE/cpumask and
> > > > the new /sys/devices/virtual/workqueue/cpumask_unbounds file.
> > >
> > > Why is there "virtual" directory in the path? Workqueues are "virtual"
> > > devices?
> >
> > I ain't an actual one.  That apparently is the preferred place to
> > present software constructs like workqueues in sysfs.
> 
> Could we fix that? A workqueue is not a device but more a kernel setting.
> 
> /sys/kernel/workqueue/.... ?

Right, that could have been more in line with slab files.  It's
already too late tho.  This has been exposed for quite a while now.
Urgh...

Thanks.

-- 
tejun
