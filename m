Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779AbaEGQhJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 12:37:09 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:53611 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925AbaEGQhI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 12:37:08 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [RFC PATCH 0/6] workqueue: Introduce low-level unbound wq sysfs cpumask v2
Date: Wed,  7 May 2014 18:36:55 +0200
Message-Id: <1399480621-19555-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is the 2nd version of https://lkml.org/lkml/2014/4/24/427

Changes in this version include:

* Allow to call apply_workqueue_attrs() on ordered workqueues and remove
the associated special cases (thanks Lai!)

* Improve error handling

* Add some lockdep_assert_held() to check locking requirements

* Rename unbounds_cpumask file to cpumask (some prefix still in discusion
with Tejun).

* Better handle widening of cpumask (see 6th patch), but need to be done
more properly, see changelog.

* Rebase on top of Tejun's workqueue next branch

Thanks,
	Frederic

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	core/workqueue-v4
---

Frederic Weisbecker (5):
      workqueue: Reorder sysfs code
      workqueue: Create low-level unbound workqueues cpumask
      workqueue: Split apply attrs code from its locking
      workqueue: Allow modifying low level unbound workqueue cpumask
      workqueue: Record real per-workqueue cpumask

Lai Jiangshan (1):
      workqueue: Allow changing attributions of ordered workqueues


 kernel/workqueue.c | 1672 ++++++++++++++++++++++++++++------------------------
 1 file changed, 896 insertions(+), 776 deletions(-)
