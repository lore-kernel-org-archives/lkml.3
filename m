Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752787AbaGNIMX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 04:12:23 -0400
Received: from cn.fujitsu.com ([59.151.112.132]:43077 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750886AbaGNIMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 04:12:18 -0400
X-IronPort-AV: E=Sophos;i="5.00,887,1396972800"; 
   d="scan'208";a="33229590"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
CC: Tejun Heo <tj@kernel.org>, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 0/1 V2] workqueue: a tiny fix for the mayday timer
Date: Mon, 14 Jul 2014 16:13:20 +0800
Message-ID: <1405325601-12437-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1405265479-827-1-git-send-email-laijs@cn.fujitsu.com>
References: <1405265479-827-1-git-send-email-laijs@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.167.226.103]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, TJ

The del_timer_sync()s for the mayday timer in maybe_create_worker()
do not meet the requirement of the document of the del_timer_sync().

V1 patch incorrectly stops the timer when !need_to_create_worker(),
but no one can restart it when needed. In V2, we stops the
timer only when manager is not working.

Sorry for the incorrect V1 due to a general excuse: World-Cup-2014.

Another patch "[PATCH 1/1 V2] workqueue: unfold start_worker() into create_worker()"
depends on this patch. That patch still coincides with this patch even
this patch is updated.

Thanks,
Lai

Lai Jiangshan (1):
  workqueue: remove the del_timer_sync()s in maybe_create_worker()

 kernel/workqueue.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

-- 
1.7.4.4

