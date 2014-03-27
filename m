Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756982AbaC0RVL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 13:21:11 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:47800 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756172AbaC0RVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 13:21:09 -0400
From: Frederic Weisbecker <fweisbec@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Christoph Lameter <cl@linux.com>,
        Kevin Hilman <khilman@linaro.org>,
        Mike Galbraith <bitbucket@online.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>, Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH 0/4] workqueue: Control cpu affinity of all unbound workqueues v2
Date: Thu, 27 Mar 2014 18:20:58 +0100
Message-Id: <1395940862-31428-1-git-send-email-fweisbec@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

So this version now handles ordered workqueues as well by changing the
affinity of ordered pools as per Tejun suggestion. See patch 4/4 for
details. I'm just not 100% sure about locking correctness.

I also fixed a few comments in patch 2/4 to better describe unbound mutex
coverage.

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/linux-dynticks.git
	core/workqueue-anon-sysfs-v2

Thanks,
	Frederic
---

Frederic Weisbecker (4):
      workqueue: Move workqueue bus attr to device attribute
      workqueues: Account unbound workqueue in a seperate list
      workqueue: Add anon workqueue sysfs hierarchy
      workqueue: Include ordered workqueues in anon workqueue sysfs interface


 kernel/workqueue.c | 201 ++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 191 insertions(+), 10 deletions(-)
