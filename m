Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635AbaCKT7Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:59:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281AbaCKT7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:59:24 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Eric Paris <eparis@redhat.com>, sgrubb@redhat.com,
        Aristeu Rozanski <arozansk@redhat.com>,
        Richard Guy Briggs <rgb@redhat.com>
Subject: [PATCH 2/2] audit: include subject in login records
Date: Tue, 11 Mar 2014 15:58:23 -0400
Message-Id: <b2b2976fbd28a7bebe40ed3848c333ccc79d6ac2.1394567663.git.rgb@redhat.com>
In-Reply-To: <cover.1394567663.git.rgb@redhat.com>
References: <cover.1394567663.git.rgb@redhat.com>
In-Reply-To: <cover.1394567663.git.rgb@redhat.com>
References: <cover.1394567663.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Paris <eparis@redhat.com>

The login uid change record does not include the selinux context of the
task logging in.  Add that information.

(Updated from 2011-01: RHBZ:670328 -- RGB)

Reported-by: Steve Grubb <sgrubb@redhat.com>
Acked-by: James Morris <jmorris@redhat.com>
Signed-off-by: Eric Paris <eparis@redhat.com>
Signed-off-by: Aristeu Rozanski <arozansk@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3bc12d2..d8a54ef 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1983,12 +1983,10 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_LOGIN);
 	if (!ab)
 		return;
-	audit_log_format(ab, "pid=%d uid=%u"
-			 " old-auid=%u auid=%u old-ses=%u ses=%u"
-			 " res=%d",
-			 task_pid_nr(current), uid,
-			 oldloginuid, loginuid, oldsessionid, sessionid,
-			 !rc);
+	audit_log_format(ab, "pid=%d uid=%u", task_pid_nr(current), uid);
+	audit_log_task_context(ab);
+	audit_log_format(ab, " old-auid=%u auid=%u old-ses=%u ses=%u res=%d",
+			 oldloginuid, loginuid, oldsessionid, sessionid, !rc);
 	audit_log_end(ab);
 }
 
-- 
1.7.1

