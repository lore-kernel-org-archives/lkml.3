Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbaIQKTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 06:19:44 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:21383 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752939AbaIQKTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 06:19:42 -0400
Message-ID: <5419602C.4080303@huawei.com>
Date: Wed, 17 Sep 2014 18:19:24 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: cgroups <cgroups@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 3/4] cgroup: remove bogus comments
References: <54195FE1.9030607@huawei.com>
In-Reply-To: <54195FE1.9030607@huawei.com>
Content-Type: text/plain; charset="GB2312"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020205.5419602F.00CA,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: 10bd0a0edae9693cf1f82130b75b131f
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We never grab cgroup mutex in fork and exit paths no matter whether
notify_on_release is set or not.

Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/cgroup.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 26b8cb9..1abb554 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -967,14 +967,6 @@ static struct cgroup *task_cgroup_from_root(struct task_struct *task,
  * knows that the cgroup won't be removed, as cgroup_rmdir()
  * needs that mutex.
  *
- * The fork and exit callbacks cgroup_fork() and cgroup_exit(), don't
- * (usually) take cgroup_mutex.  These are the two most performance
- * critical pieces of code here.  The exception occurs on cgroup_exit(),
- * when a task in a notify_on_release cgroup exits.  Then cgroup_mutex
- * is taken, and if the cgroup count is zero, a usermode call made
- * to the release agent with the name of the cgroup (path relative to
- * the root of cgroup file system) as the argument.
- *
  * A cgroup can only be deleted if both its 'count' of using tasks
  * is zero, and its list of 'children' cgroups is empty.  Since all
  * tasks in the system use _some_ cgroup, and since there is always at
-- 
1.8.0.2

