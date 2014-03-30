Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751749AbaC3M55 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Mar 2014 08:57:57 -0400
Received: from mail-qg0-f46.google.com ([209.85.192.46]:63457 "EHLO
	mail-qg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751265AbaC3M54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Mar 2014 08:57:56 -0400
Date: Sun, 30 Mar 2014 08:57:51 -0400
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: [PATCH 2/4] workqueues: Account unbound workqueue in a seperate
 list
Message-ID: <20140330125751.GC8942@htj.dyndns.org>
References: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
 <1395940862-31428-3-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395940862-31428-3-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 06:21:00PM +0100, Frederic Weisbecker wrote:
> The workqueues are all listed in a global list protected by a big mutex.
> And this big mutex is used in apply_workqueue_attrs() as well.
> 
> Now as we plan to implement a directory to control the cpumask of
> all non-ABI unbound workqueues, we want to be able to iterate over all
> unbound workqueues and call apply_workqueue_attrs() for each of
> them with the new cpumask.
> 
> But the risk for a deadlock is on the way: we need to iterate the list
> of workqueues under wq_pool_mutex. But then apply_workqueue_attrs()
> itself calls wq_pool_mutex.

Wouldn't the right thing to do would be factoring out
apply_workqueue_attrs_locked()?  It's cleaner to block out addition of
new workqueues while the masks are being updated anyway.

Thanks.

-- 
tejun
