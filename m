Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356AbbANIxl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 03:53:41 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:12615 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756321AbbANIxi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 03:53:38 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="56041178"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>, Tejun Heo <tj@kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "Gu, Zheng" <guz.fnst@cn.fujitsu.com>,
        tangchen <tangchen@cn.fujitsu.com>,
        Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [RFC PATCH 0/2 shit_A shit_B] workqueue: fix wq_numa bug
Date: Wed, 14 Jan 2015 16:54:14 +0800
Message-ID: <1421225658-3978-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <54B5D8B4.7010708@cn.fujitsu.com>
References: <54B5D8B4.7010708@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All

This patches are un-changloged, un-compiled, un-booted, un-tested,
they are just shits, I even hope them un-sent or blocked.

The patches include two -solutions-:

Shit_A:
  workqueue: reset pool->node and unhash the pool when the node is
    offline
  update wq_numa when cpu_present_mask changed

 kernel/workqueue.c | 107 +++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 84 insertions(+), 23 deletions(-)


Shit_B:
  workqueue: reset pool->node and unhash the pool when the node is
    offline
  workqueue: remove wq_numa_possible_cpumask
  workqueue: directly update attrs of pools when cpu hot[un]plug

 kernel/workqueue.c | 135 +++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 101 insertions(+), 34 deletions(-)


Both patch1 of the both solutions are: reset pool->node and unhash the pool,
it is suggested by TJ, I found it is a good leading-step for fixing the bug.

The other patches are handling wq_numa_possible_cpumask where the solutions
diverge.

Solution_A uses present_mask rather than possible_cpumask. It adds
wq_numa_notify_cpu_present_set/cleared() for notifications of
the changes of cpu_present_mask.  But the notifications are un-existed
right now, so I fake one (wq_numa_check_present_cpumask_changes())
to imitate them.  I hope the memory people add a real one.

Solution_B uses online_mask rather than possible_cpumask.
this solution remove more coupling between numa_code and workqueue,
it just depends on cpumask_of_node(node).

Patch2_of_Solution_B removes the wq_numa_possible_cpumask and add
overhead when cpu hot[un]plug, Patch3 reduce this overhead.

Thanks,
Lai


Reported-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: "Gu, Zheng" <guz.fnst@cn.fujitsu.com>
Cc: tangchen <tangchen@cn.fujitsu.com>
Cc: Hiroyuki KAMEZAWA <kamezawa.hiroyu@jp.fujitsu.com>
-- 
2.1.0

