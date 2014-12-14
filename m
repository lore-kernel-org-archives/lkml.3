Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbaLNOGz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:06:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44208 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468AbaLNOGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:06:48 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 2/2] Fix no idle state information return value
Date: Sun, 14 Dec 2014 09:06:38 -0500
Message-Id: <1418565998-3701-3-git-send-email-prarit@redhat.com>
In-Reply-To: <1418565998-3701-1-git-send-email-prarit@redhat.com>
References: <1418565998-3701-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sysfs_get_idlestate_count() returns an unsigned int.  Returning -ENODEV
is not the right thing to do here, and in any case is handled the same
way as if there are no states found.

Cc: Thomas Renninger <trenn@suse.de>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 tools/power/cpupower/utils/helpers/sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
index 09afe5d..4e8fe2c 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -361,7 +361,7 @@ unsigned int sysfs_get_idlestate_count(unsigned int cpu)
 
 	snprintf(file, SYSFS_PATH_MAX, PATH_TO_CPU "cpuidle");
 	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))
-		return -ENODEV;
+		return 0;
 
 	snprintf(file, SYSFS_PATH_MAX, PATH_TO_CPU "cpu%u/cpuidle/state0", cpu);
 	if (stat(file, &statbuf) != 0 || !S_ISDIR(statbuf.st_mode))
-- 
1.7.9.3

