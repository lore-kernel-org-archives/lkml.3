Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932387Ab3CLGva (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 02:51:30 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:43642 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab3CLGv3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 02:51:29 -0400
Message-ID: <513ED052.7080907@huawei.com>
Date: Tue, 12 Mar 2013 14:50:58 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130307 Thunderbird/17.0.4
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 5/8] cgroup: remove useless code in cgroup_write_event_control()
References: <513ED010.5060906@huawei.com>
In-Reply-To: <513ED010.5060906@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eventfd_poll() never returns POLLHUP.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 58ae040..3206137 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -3938,12 +3938,6 @@ static int cgroup_write_event_control(struct cgroup *cgrp, struct cftype *cft,
 	if (ret)
 		goto fail;
 
-	if (efile->f_op->poll(efile, &event->pt) & POLLHUP) {
-		event->cft->unregister_event(cgrp, event->cft, event->eventfd);
-		ret = 0;
-		goto fail;
-	}
-
 	/*
 	 * Events should be removed after rmdir of cgroup directory, but before
 	 * destroying subsystem state objects. Let's take reference to cgroup
-- 
1.8.0.2
