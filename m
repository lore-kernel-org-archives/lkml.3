Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521AbaDQOMt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 10:12:49 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:49116 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaDQOMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 10:12:18 -0400
From: Peter Foley <pefoley2@pefoley.com>
To: linux-kernel@vger.kernel.org
Cc: rdunlap@infradead.org, linux-doc@vger.kernel.org,
        Peter Foley <pefoley2@pefoley.com>
Subject: [PATCH 4/4] Documentation: fix misc. warnings
Date: Thu, 17 Apr 2014 10:11:50 -0400
Message-Id: <1397743910-18391-4-git-send-email-pefoley2@pefoley.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
References: <1397743910-18391-1-git-send-email-pefoley2@pefoley.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a few warnings that gcc emits during a default build.

Signed-off-by: Peter Foley <pefoley2@pefoley.com>
---
 Documentation/laptops/hpfall.c  | 9 +++++++--
 Documentation/mic/mpssd/mpssd.c | 4 ++--
 Documentation/ptp/testptp.c     | 6 +++---
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/Documentation/laptops/hpfall.c b/Documentation/laptops/hpfall.c
index d4e1380..3e04fc1 100644
--- a/Documentation/laptops/hpfall.c
+++ b/Documentation/laptops/hpfall.c
@@ -74,14 +74,16 @@ static void protect(int seconds)
 static int on_ac(void)
 {
 //	/sys/class/power_supply/AC0/online
+	return 0;
 }
 
 static int lid_open(void)
 {
 //	/proc/acpi/button/lid/LID/state
+	return 0;
 }
 
-static void ignore_me(void)
+static void ignore_me(int ignored)
 {
 	protect(0);
 	set_led(0);
@@ -111,7 +113,10 @@ int main(int argc, char **argv)
 		return EXIT_FAILURE;
 	}
 
-	daemon(0, 0);
+	if (daemon(0, 0) < 0) {
+		perror("daemonization failed");
+		return EXIT_FAILURE;
+	}
 	param.sched_priority = sched_get_priority_max(SCHED_FIFO);
 	sched_setscheduler(0, SCHED_FIFO, &param);
 	mlockall(MCL_CURRENT|MCL_FUTURE);
diff --git a/Documentation/mic/mpssd/mpssd.c b/Documentation/mic/mpssd/mpssd.c
index 4d17487..24203dd 100644
--- a/Documentation/mic/mpssd/mpssd.c
+++ b/Documentation/mic/mpssd/mpssd.c
@@ -1476,9 +1476,9 @@ set_cmdline(struct mic_info *mic)
 
 	len = snprintf(buffer, PATH_MAX,
 		"clocksource=tsc highres=off nohz=off ");
-	len += snprintf(buffer + len, PATH_MAX,
+	len += snprintf(buffer + len, PATH_MAX - len,
 		"cpufreq_on;corec6_off;pc3_off;pc6_off ");
-	len += snprintf(buffer + len, PATH_MAX,
+	len += snprintf(buffer + len, PATH_MAX - len,
 		"ifcfg=static;address,172.31.%d.1;netmask,255.255.255.0",
 		mic->id);
 
diff --git a/Documentation/ptp/testptp.c b/Documentation/ptp/testptp.c
index f1ac2da..913b7ba 100644
--- a/Documentation/ptp/testptp.c
+++ b/Documentation/ptp/testptp.c
@@ -497,11 +497,11 @@ int main(int argc, char *argv[])
 			interval = t2 - t1;
 			offset = (t2 + t1) / 2 - tp;
 
-			printf("system time: %" PRId64 ".%u\n",
+			printf("system time: %lld.%u\n",
 				(pct+2*i)->sec, (pct+2*i)->nsec);
-			printf("phc    time: %" PRId64 ".%u\n",
+			printf("phc    time: %lld.%u\n",
 				(pct+2*i+1)->sec, (pct+2*i+1)->nsec);
-			printf("system time: %" PRId64 ".%u\n",
+			printf("system time: %lld.%u\n",
 				(pct+2*i+2)->sec, (pct+2*i+2)->nsec);
 			printf("system/phc clock time offset is %" PRId64 " ns\n"
 			       "system     clock time delay  is %" PRId64 " ns\n",
-- 
1.9.2

