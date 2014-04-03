Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752391AbaDCO6Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:58:16 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:65357 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243AbaDCO6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:58:09 -0400
Date: Thu, 3 Apr 2014 10:58:05 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 3/4] workqueue: Add anon workqueue sysfs hierarchy
Message-ID: <20140403145805.GC24119@htj.dyndns.org>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
 <1395940862-31428-4-git-send-email-fweisbec@gmail.com>
 <20140330130139.GD8942@htj.dyndns.org>
 <20140403144250.GD23338@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140403144250.GD23338@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Frederic.

On Thu, Apr 03, 2014 at 04:42:55PM +0200, Frederic Weisbecker wrote:
> > I'm not really sure this is the good approach.  I think I wrote this
> > way back but wouldn't it make more sense to allow userland to restrict
> > the cpus which are allowed to all unbound cpus.  As currently
> > implemented, setting WQ_SYSFS to give userland more control would
> > escape that workqueue from this global mask as a side effect, which is
> > a surprising behavior and doesn't make much sense to me.
> 
> I just considered that anon workqueues shouldn't be that different from
> another WQ_SYSFS workqueue. This way we don't have suprising side effect.
> Touching a WQ_SYSFS doesn't impact anon workqueues, and touching anon workqueues
> doesn't impact WQ_SYSFS workqueues.

I really think it'd be a lot better to perceive the default attributes
to be layered below explicit WQ_SYSFS attributes; otherwise, we have
two disjoint sets and the workqueues would jump between the two
depending on WQ_SYSFS.  A system tool which wants to configure all
workqueues would have to scan and manipulate all of them not knowing
what specific one's requirements are and tools which want to configure
specific ones likely won't know what the overruling condition is and
violate the global contraints.  It'd be clearer to have the layering
pre-defined and enforced.

> In fact this is simply the current way we do it, just extended.

Yes, in term of mechanics, it is but I don't think that's what we
want.  We want to be able to say "unbound workqueues in general are
confined to these cpus" and it's weird to just provide knobs for wqs
which don't have knobs.

> Yeah I like this. So the right place for this cpumask would be in
> the root of /sys/devices/virtual/workqueue/ , right?

Yes, I think that'd make more sense.

Thanks.

-- 
tejun
