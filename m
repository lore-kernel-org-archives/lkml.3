Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456AbaDCOsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 10:48:32 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:64287 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752217AbaDCOsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 10:48:31 -0400
Date: Thu, 3 Apr 2014 16:48:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/4] workqueues: Account unbound workqueue in a seperate
 list
Message-ID: <20140403144826.GE23338@localhost.localdomain>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
 <1395940862-31428-3-git-send-email-fweisbec@gmail.com>
 <20140330125751.GC8942@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140330125751.GC8942@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 30, 2014 at 08:57:51AM -0400, Tejun Heo wrote:
> On Thu, Mar 27, 2014 at 06:21:00PM +0100, Frederic Weisbecker wrote:
> > The workqueues are all listed in a global list protected by a big mutex.
> > And this big mutex is used in apply_workqueue_attrs() as well.
> > 
> > Now as we plan to implement a directory to control the cpumask of
> > all non-ABI unbound workqueues, we want to be able to iterate over all
> > unbound workqueues and call apply_workqueue_attrs() for each of
> > them with the new cpumask.
> > 
> > But the risk for a deadlock is on the way: we need to iterate the list
> > of workqueues under wq_pool_mutex. But then apply_workqueue_attrs()
> > itself calls wq_pool_mutex.
> 
> Wouldn't the right thing to do would be factoring out
> apply_workqueue_attrs_locked()?  It's cleaner to block out addition of
> new workqueues while the masks are being updated anyway.

I'm not quite sure I get what you suggest. Do you mean have apply_workqueue_attrs_locked()
calling apply_workqueue_attrs() under the lock on this patch?

Thanks.
