Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3DNQmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 12:42:32 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:7156 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752061Ab3DNQmb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 12:42:31 -0400
X-IronPort-AV: E=Sophos;i="4.87,471,1363104000"; 
   d="scan'208";a="7051541"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/8] workqueue: advance concurrency management
Date: Mon, 15 Apr 2013 00:41:48 +0800
Message-Id: <1365957716-7631-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:40:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/04/15 00:40:46,
	Serialize complete at 2013/04/15 00:40:46
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found the early-increasing nr_running in wq_worker_waking_up() is useless
in many cases. it tries to avoid waking up idle workers for pending work item.
but delay increasing nr_running does not increase waking up idle workers.

so we delay increasing and remove wq_worker_waking_up() and ...

enjoy a simpler concurrency management.

Lai Jiangshan (8):
  workqueue: remove @cpu from wq_worker_sleeping()
  workqueue: use create_and_start_worker() in manage_workers()
  workqueue: remove cpu_intensive from process_one_work()
  workqueue: quit cm mode when sleeping
  workqueue: remove disabled wq_worker_waking_up()
  workqueue: make nr_running non-atomic
  workqueue: move worker->flags up
  workqueue: rename ->nr_running to ->nr_cm_workers

 kernel/sched/core.c         |    6 +-
 kernel/workqueue.c          |  234 +++++++++++++++---------------------------
 kernel/workqueue_internal.h |    9 +-
 3 files changed, 89 insertions(+), 160 deletions(-)

-- 
1.7.7.6

