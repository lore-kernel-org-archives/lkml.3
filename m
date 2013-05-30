Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967725Ab3E3HIR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 May 2013 03:08:17 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:25445 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S967670Ab3E3HIK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 May 2013 03:08:10 -0400
X-IronPort-AV: E=Sophos;i="4.87,769,1363104000"; 
   d="scan'208";a="7410466"
From: liguang <lig.fnst@cn.fujitsu.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        liguang <lig.fnst@cn.fujitsu.com>
Subject: [PATCH] powerpc/pseries: use 'true' instead of '1' for orderly_poweroff
Date: Thu, 30 May 2013 15:07:31 +0800
Message-Id: <1369897651-23770-1-git-send-email-lig.fnst@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.2.5
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:06:36,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2013/05/30 15:06:37,
	Serialize complete at 2013/05/30 15:06:37
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

orderly_poweroff is expecting a bool parameter, so
use 'ture' instead '1'

Signed-off-by: liguang <lig.fnst@cn.fujitsu.com>
---
 arch/powerpc/platforms/pseries/ras.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/ras.c b/arch/powerpc/platforms/pseries/ras.c
index c4dfccd..79b9502 100644
--- a/arch/powerpc/platforms/pseries/ras.c
+++ b/arch/powerpc/platforms/pseries/ras.c
@@ -83,7 +83,7 @@ static void handle_system_shutdown(char event_modifier)
 	switch (event_modifier) {
 	case EPOW_SHUTDOWN_NORMAL:
 		pr_emerg("Firmware initiated power off");
-		orderly_poweroff(1);
+		orderly_poweroff(true);
 		break;
 
 	case EPOW_SHUTDOWN_ON_UPS:
@@ -95,13 +95,13 @@ static void handle_system_shutdown(char event_modifier)
 		pr_emerg("Loss of system critical functions reported by "
 			"firmware");
 		pr_emerg("Check RTAS error log for details");
-		orderly_poweroff(1);
+		orderly_poweroff(true);
 		break;
 
 	case EPOW_SHUTDOWN_AMBIENT_TEMPERATURE_TOO_HIGH:
 		pr_emerg("Ambient temperature too high reported by firmware");
 		pr_emerg("Check RTAS error log for details");
-		orderly_poweroff(1);
+		orderly_poweroff(true);
 		break;
 
 	default:
@@ -162,7 +162,7 @@ void rtas_parse_epow_errlog(struct rtas_error_log *log)
 
 	case EPOW_SYSTEM_HALT:
 		pr_emerg("Firmware initiated power off");
-		orderly_poweroff(1);
+		orderly_poweroff(ture);
 		break;
 
 	case EPOW_MAIN_ENCLOSURE:
-- 
1.7.2.5

