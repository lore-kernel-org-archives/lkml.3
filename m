Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753760AbaGKNML (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 09:12:11 -0400
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38426 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753385AbaGKNMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 09:12:09 -0400
Date: Fri, 11 Jul 2014 15:11:59 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [RFC PATCH 0/5] workqueue: Introduce low-level unbound wq sysfs
 cpumask v3
Message-ID: <20140711131155.GA26045@localhost.localdomain>
References: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
 <53BFA34F.9010800@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53BFA34F.9010800@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 04:41:51PM +0800, Lai Jiangshan wrote:
> Hi, Frederic
> 
> I'd like to take this work unless you are still working on it.
> I would do some cleanup at first so that it will be much slow for me.

Hi Lai,

I was about to iterate again on that patchset but I would certainly be
happy if you take it given the amount of stuff in my TODO list.

I suggest you to take this branch:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	core/workqueue-v6

It's a big rebase on top of latest -rc1.

Also I suggest you to use "--patience" on git diff/log/format-patch etc...
because the changes contain big code move (like the sysfs part) that default
diff doesn't display well.

I can still help you on this patchset BTW if you need. I believe that
delayed workqueues weren't well handled with it, maybe I should
check further if they need some more treatment.

Thanks.

> 
> Thanks,
> Lai
> 
> 
> On 05/17/2014 12:16 AM, Frederic Weisbecker wrote:
> > So in this version I actually save the cpumask belonging to wq (before
> > it's intersected against the low level cpumask) in its unbounds attrs.
> > 
> > But the attrs passed to pwq and worker pools have the low level cpumask
> > computed against the wq cpumask.
> > 
> > It makes it easier that way as the wq cpumask itself remains untouched.
> > It's a user setting so it must stay intact. OTOH the cpumask of pwqs and
> > worker pools only belong to the implementation so it's the right
> > place to store the effective cpumask.
> > 
> > Also wq_update_unbound_numa() is fixed, and cpu_possible_mask() 
> > is restored as a base. Thanks to Lai!
> > 
> > Thanks,
> > 	Frederic
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
> >         core/workqueue-v5
> > ---
> > 
> > Frederic Weisbecker (4):
> >       workqueue: Reorder sysfs code
> >       workqueue: Create low-level unbound workqueues cpumask
> >       workqueue: Split apply attrs code from its locking
> >       workqueue: Allow modifying low level unbound workqueue cpumask
> > 
> > Lai Jiangshan (1):
> >       workqueue: Allow changing attributions of ordered workqueues
> > 
> > 
> >  kernel/workqueue.c | 1674 ++++++++++++++++++++++++++++------------------------
> >  1 file changed, 900 insertions(+), 774 deletions(-)
> > .
> > 
> 
