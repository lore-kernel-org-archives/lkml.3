Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755878AbaGSTO3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 15:14:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45826 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbaGSTO1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 15:14:27 -0400
From: Andrey Utkin <andrey.krieger.utkin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, dcb314@hotmail.com,
        rafael.j.wysocki@intel.com, trenn@suse.de, linux@dominikbrodowski.net,
        linux-pm@vger.kernel.org,
        Andrey Utkin <andrey.krieger.utkin@gmail.com>
Subject: [PATCH 1/5] tools/power/cpupower/utils/helpers/sysfs.c: drop negativity check on unsigned value
Date: Sat, 19 Jul 2014 22:14:04 +0300
Message-Id: <1405797244-5182-1-git-send-email-andrey.krieger.utkin@gmail.com>
X-Mailer: git-send-email 1.8.5.5
In-Reply-To: <1405697445-23620-1-git-send-email-andrey.krieger.utkin@gmail.com>
References: <1405697445-23620-1-git-send-email-andrey.krieger.utkin@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resubmitting to send also to linux-pm@vger.kernel.org as requested by
Rafael J. Wysocki <rafael.j.wysocki@intel.com>

---8<---

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=80621
Reported-by: David Binderman <dcb314@hotmail.com>
Signed-off-by: Andrey Utkin <andrey.krieger.utkin@gmail.com>
---
 tools/power/cpupower/utils/helpers/sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/cpupower/utils/helpers/sysfs.c b/tools/power/cpupower/utils/helpers/sysfs.c
index 851c7a1..09afe5d 100644
--- a/tools/power/cpupower/utils/helpers/sysfs.c
+++ b/tools/power/cpupower/utils/helpers/sysfs.c
@@ -81,7 +81,7 @@ int sysfs_is_cpu_online(unsigned int cpu)
 	close(fd);
 
 	value = strtoull(linebuf, &endp, 0);
-	if (value > 1 || value < 0)
+	if (value > 1)
 		return -EINVAL;
 
 	return value;
-- 
1.8.5.5

