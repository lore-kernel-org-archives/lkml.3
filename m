Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbbAFQ6V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 11:58:21 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:51439 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752073AbbAFQ6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 11:58:19 -0500
Date: Tue, 6 Jan 2015 11:58:15 -0500
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 cgroup/for-3.20] cgroup: add dummy css_put() for
 !CONFIG_CGROUPS
Message-ID: <20150106165815.GJ3077@htj.dyndns.org>
References: <20150106165720.GI3077@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106165720.GI3077@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will later be depended upon by the scheduled cgroup writeback
support.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup.h |    4 ++++
 1 file changed, 4 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -943,6 +943,8 @@ struct cgroup_subsys_state *css_tryget_o
 
 #else /* !CONFIG_CGROUPS */
 
+struct cgroup_subsys_state;
+
 static inline int cgroup_init_early(void) { return 0; }
 static inline int cgroup_init(void) { return 0; }
 static inline void cgroup_fork(struct task_struct *p) {}
@@ -955,6 +957,8 @@ static inline int cgroupstats_build(stru
 	return -EINVAL;
 }
 
+static inline void css_put(struct cgroup_subsys_state *css) {}
+
 /* No cgroups - nothing to do */
 static inline int cgroup_attach_task_all(struct task_struct *from,
 					 struct task_struct *t)
