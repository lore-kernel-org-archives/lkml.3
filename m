Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573AbaDXOhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 10:37:45 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:47278 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756018AbaDXOhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 10:37:43 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC PATCH 0/4] workqueue: Introduce low-level unbound wq sysfs cpumask
Date: Thu, 24 Apr 2014 16:37:32 +0200
Message-Id: <1398350256-7834-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So this new version takes another direction suggested by Tejun.
Now we have a cpumask at the root of the workqueue directory
to bound the affinity of all unbound workqueues.

It's an early release as more plumbing is required. Most notably:

* Drop last patch and integrate Lai's instead to support
apply_workqueue_attrs() on ordered workqueues: https://lkml.org/lkml/2014/4/15/181

* Handle cpumask value expansion (in fact the per wq cpumask must be
stored seperately than the effective cpumask to handle that correctly).
I should take care of that in the next version.

But I prefer to post the current state now in case I'm wandering off.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	core/workqueue-v3

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      workqueue: Create low-level unbound workqueues cpumask
      workqueue: Split apply attrs code from its locking
      workqueue: Allow modifying low level unbound workqueue cpumask
      workqueue: Handle ordered workqueues on cpumask_unbounds change


 kernel/workqueue.c | 219 ++++++++++++++++++++++++++++++++++++++++++++---------
 1 file changed, 185 insertions(+), 34 deletions(-)
