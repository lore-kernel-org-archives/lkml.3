Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab3BRQMd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:12:33 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:51228 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751652Ab3BRQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:12:32 -0500
X-IronPort-AV: E=Sophos;i="4.84,688,1355068800"; 
   d="scan'208";a="6724937"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH V2 00/15] workqueue: enhance locking and lookup worker via ID
Date: Tue, 19 Feb 2013 00:12:01 +0800
Message-Id: <1361203940-6300-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.7.6
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:11:52,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/02/19 00:11:52,
	Serialize complete at 2013/02/19 00:11:52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Core patches are patch 1, patch 9, patch 13

Patch 1: enhance locking
Patch 9: recorde worker id to work->data instead of pool id
	 lookup worker via worker ID if offq
Patch 13:also lookup worker via worker ID if running&&queued,
	 remove lookup via hashtable

Patch 6-8: ensure modification to worker->pool is under pool lock held
Patch 14: remove hashtable totally

other patch is preparing-patch or cleanup.


Lai Jiangshan (15):
  workqueue: add lock_work_pool()
  workqueue: allow more work_pool id space
  workqueue: remname worker->id to worker->id_in_pool
  workqueue: add worker's global worker ID
  workqueue: only set pool id when the work is running
  workqueue: use current instead of worker->task in
    worker_maybe_bind_and_lock()
  workqueue: change argument of worker_maybe_bind_and_lock() to pool
  workqueue: only change worker->pool with pool lock held
  workqueue: use worker id instead
  workqueue: avoid unneeded calls to get_work_cwq(work)
  workqueue: split work_flags to delayed_flags and color_flags in
    __queue_work()
  workqueue: add extra flags to set_work_worker_and_keep_pending()
  workqueue: also record worker in work->data if running&&queued
  workqueue: convert busy hash to busy list
  workqueue: queue worker to busy list

 include/linux/workqueue.h   |   25 +-
 kernel/workqueue.c          |  522 ++++++++++++++++++++++++-------------------
 kernel/workqueue_internal.h |   17 +-
 3 files changed, 314 insertions(+), 250 deletions(-)

-- 
1.7.7.6

