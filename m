Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759303Ab3GaISW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 04:18:22 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:31511 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233Ab3GaISR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 04:18:17 -0400
Message-ID: <51F8C83F.6010407@huawei.com>
Date: Wed, 31 Jul 2013 16:18:07 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: [PATCH 6/7] cgroup: rename current_css_set_cg_links
References: <51F8C7C5.9040608@huawei.com>
In-Reply-To: <51F8C7C5.9040608@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As we've renamed css_set->cg_links to css_set->cgrp_links (See commit
69d0206c79 "cgroup: bring some sanity to naming around cg_cgroup_link"),
it's better to also rename the debug file.

As the "debug" cgroup subsystem is for debug only and acts as a sample
on how to write a cgroup subsystem, it's fine to change the interface.

Signed-off-by: Li Zefan <lizefan@huawei.com>
---
 kernel/cgroup.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ac77d87..89d63b0 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -5312,9 +5312,9 @@ static u64 current_css_set_refcount_read(struct cgroup *cgrp,
 	return count;
 }
 
-static int current_css_set_cg_links_read(struct cgroup *cgrp,
-					 struct cftype *cft,
-					 struct seq_file *seq)
+static int current_css_set_cgrp_links_read(struct cgroup *cgrp,
+					   struct cftype *cft,
+					   struct seq_file *seq)
 {
 	struct cgrp_cset_link *link;
 	struct css_set *cset;
@@ -5387,8 +5387,8 @@ static struct cftype debug_files[] =  {
 	},
 
 	{
-		.name = "current_css_set_cg_links",
-		.read_seq_string = current_css_set_cg_links_read,
+		.name = "current_css_set_cgrp_links",
+		.read_seq_string = current_css_set_cgrp_links_read,
 	},
 
 	{
-- 
1.8.0.2
