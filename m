Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752312AbaGZDEH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 23:04:07 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:52648 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751815AbaGZDEF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 23:04:05 -0400
X-IronPort-AV: E=Sophos;i="5.00,965,1396972800"; 
   d="scan'208";a="33802424"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/3] workqueue: offload the worker-management out from kworker
Date: Sat, 26 Jul 2014 11:04:48 +0800
Message-ID: <1406343900-32423-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current kworker prefer creating worker (if required) to processing work items,
we hope the processing should be the first priority.

The jobs in managers are serialized, it is just wasting if we have multiple
managers, only one worker-creater is enough.

It causes much complication and tricky when manager is implemented inside
worker, using dedicated creater will make things more flexible.

So we offload the worker-management out from kworker into a single
dedicated creater kthread.  It is done in patch2. And the patch1 is
preparation and patch3 is cleanup patch.

Lai Jiangshan (3):
  workqueue: migrate the new worker before add it to idle_list
  workqueue: use dedicated creater kthread for all pools
  workqueue: cleanup may_start_working()

 kernel/workqueue.c |  228 ++++++++++++++++++++++------------------------------
 1 files changed, 96 insertions(+), 132 deletions(-)

-- 
1.7.4.4

