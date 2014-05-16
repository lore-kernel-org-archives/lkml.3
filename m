Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757566AbaEPQRF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 12:17:05 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:63656 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753215AbaEPQRD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 12:17:03 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC PATCH 0/5] workqueue: Introduce low-level unbound wq sysfs cpumask v3
Date: Fri, 16 May 2014 18:16:50 +0200
Message-Id: <1400257015-28222-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So in this version I actually save the cpumask belonging to wq (before
it's intersected against the low level cpumask) in its unbounds attrs.

But the attrs passed to pwq and worker pools have the low level cpumask
computed against the wq cpumask.

It makes it easier that way as the wq cpumask itself remains untouched.
It's a user setting so it must stay intact. OTOH the cpumask of pwqs and
worker pools only belong to the implementation so it's the right
place to store the effective cpumask.

Also wq_update_unbound_numa() is fixed, and cpu_possible_mask() 
is restored as a base. Thanks to Lai!

Thanks,
	Frederic

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
        core/workqueue-v5
---

Frederic Weisbecker (4):
      workqueue: Reorder sysfs code
      workqueue: Create low-level unbound workqueues cpumask
      workqueue: Split apply attrs code from its locking
      workqueue: Allow modifying low level unbound workqueue cpumask

Lai Jiangshan (1):
      workqueue: Allow changing attributions of ordered workqueues


 kernel/workqueue.c | 1674 ++++++++++++++++++++++++++++------------------------
 1 file changed, 900 insertions(+), 774 deletions(-)
