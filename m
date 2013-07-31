Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759220Ab3GaIQy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:16:54 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:29718 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759199Ab3GaIQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:16:52 -0400
Message-ID: <51F8C7E8.1080909@huawei.com>
Date: Wed, 31 Jul 2013 16:16:40 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 2/7] cgroup: remove sparse tags from offline_css()
References: <51F8C7C5.9040608@huawei.com>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should have been removed in commit d7eeac1913ff
("cgroup: hold cgroup_mutex before calling css_offline").

While at it, update the comments.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index e60eba2..916a699 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4164,7 +4164,7 @@ static void init_cgroup_css(struct cgroup_subsys_state *css,
 	INIT_WORK(&css->dput_work, css_dput_fn);
 }
 
-/* invoke ->post_create() on a new CSS and mark it online if successful */
+/* invoke ->css_online() on a new CSS and mark it online if successful */
 static int online_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 {
 	int ret = 0;
@@ -4178,9 +4178,8 @@ static int online_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 	return ret;
 }
 
-/* if the CSS is online, invoke ->pre_destory() on it and mark it offline */
+/* if the CSS is online, invoke ->css_offline() on it and mark it offline */
 static void offline_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
-	__releases(&cgroup_mutex) __acquires(&cgroup_mutex)
 {
 	struct cgroup_subsys_state *css = cgrp->subsys[ss->subsys_id];
 
-- 
1.8.0.2
