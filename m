Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934160Ab3DGR2Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 13:28:25 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:51362 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934138Ab3DGR2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 13:28:23 -0400
Date: Sun, 7 Apr 2013 10:28:18 -0700
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizefan@huawei.com>, Aristeu Rozanski <aris@redhat.com>
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH cgroup/for-3.10] devcg: remove broken_hierarchy tag
Message-ID: <20130407172818.GD12038@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From f913fbedbdfc08eeff742c4b3077e267d8fc867f Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj@kernel.org>
Date: Sun, 7 Apr 2013 10:25:39 -0700

bd2953ebbb ("devcg: propagate local changes down the hierarchy")
implemented proper hierarchy support.  Remove the broken tag.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Aristeu Rozanski <aris@redhat.com>
---
Applying to cgroup/for-3.10.

Thanks.

 security/device_cgroup.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/security/device_cgroup.c b/security/device_cgroup.c
index 221967d..994aecc 100644
--- a/security/device_cgroup.c
+++ b/security/device_cgroup.c
@@ -739,15 +739,6 @@ struct cgroup_subsys devices_subsys = {
 	.css_offline = devcgroup_offline,
 	.subsys_id = devices_subsys_id,
 	.base_cftypes = dev_cgroup_files,
-
-	/*
-	 * While devices cgroup has the rudimentary hierarchy support which
-	 * checks the parent's restriction, it doesn't properly propagates
-	 * config changes in ancestors to their descendents.  A child
-	 * should only be allowed to add more restrictions to the parent's
-	 * configuration.  Fix it and remove the following.
-	 */
-	.broken_hierarchy = true,
 };
 
 /**
-- 
1.8.1.4

