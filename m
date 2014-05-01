Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaEAPBX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 11:01:23 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:47330 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbaEAPBV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 11:01:21 -0400
Date: Thu, 1 May 2014 17:01:17 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 1/4] workqueue: Create low-level unbound workqueues
 cpumask
Message-ID: <20140501150114.GD25369@localhost.localdomain>
References: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
 <1398350256-7834-2-git-send-email-fweisbec@gmail.com>
 <20140424153716.GG14460@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140424153716.GG14460@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 24, 2014 at 11:37:16AM -0400, Tejun Heo wrote:
> On Thu, Apr 24, 2014 at 04:37:33PM +0200, Frederic Weisbecker wrote:
> > Create a cpumask that limit the affinity of all unbound workqueues.
> > This cpumask is controlled though a file at the root of the workqueue
> > sysfs directory.
> > 
> > It works on a lower-level than the per WQ_SYSFS workqueues cpumask files
> > such that the effective cpumask applied for a given unbound workqueue is
> > the intersection of /sys/devices/virtual/workqueue/$WORKQUEUE/cpumask and
> > the new /sys/devices/virtual/workqueue/cpumask_unbounds file.
> 
> Let's drop "_unbounds" postfix and name it just "cpumask".  We don't
> apply it to per-cpu workqueues now but that really is an
> implementation detail and later when (and if) we actually distinguish
> per-cpu usages for correctness from for optimization, we may as well
> apply the same cpumask to per-cpu ones too.

Makes sense. But I hope this won't confused too much people. Having
a cpumask file suggests it applies to all of them.

> 
> Another thing with naming is that I didn't anticipate having
> attributes at the top directory so the workqueue directories aren't
> namespaced.  Maybe we want to namespace top level knobs?
> "system_cpumask" maybe?  Any better ideas?

Not sure why you want that. It makes sense on directories grouping
file for different subsystem. But here?

Thanks.
