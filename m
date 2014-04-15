Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751203AbaDOWFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 18:05:10 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44551 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750924AbaDOWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 18:05:07 -0400
Date: Tue, 15 Apr 2014 18:05:04 -0400
From: Tejun Heo <tj@kernel.org>
To: lizefan@huawei.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0.5/12] cgroup: cgroup_apply_cftypes() shouldn't skip the
 default hierarhcy
Message-ID: <20140415220504.GA13099@mtj.dyndns.org>
References: <1395974461-12735-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395974461-12735-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From c7596b2f33e9f7a57cef6909c30fec268e921c3b Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Tue, 15 Apr 2014 18:02:12 -0400

cgroup_apply_cftypes() skip creating or removing files if the
subsystem is attached to the default hierarchy, which led to missing
files in the root of the default hierarchy.

Skipping made sense when the default hierarchy was dummy; however, now
that the default hierarchy is full functional and planned to be used
as the unified hierarchy, it shouldn't be skipped over.

Reported-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 9fcdaa7..fbcc710 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -2436,10 +2436,6 @@ static int cgroup_apply_cftypes(struct cftype *cfts, bool is_add)
 
 	lockdep_assert_held(&cgroup_tree_mutex);
 
-	/* don't bother if @ss isn't attached */
-	if (ss->root == &cgrp_dfl_root)
-		return 0;
-
 	/* add/rm files for all cgroups created before */
 	css_for_each_descendant_pre(css, cgroup_css(root, ss)) {
 		struct cgroup *cgrp = css->cgroup;
-- 
1.9.0

