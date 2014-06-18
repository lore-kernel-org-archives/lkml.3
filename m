Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932794AbaFRB25 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 21:28:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4885 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755460AbaFRB24 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 21:28:56 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: stable@vger.kernel.org, linux-audit@redhat.com,
        linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, bigon@debian.org, sgrubb@redhat.com,
        eparis@redhat.com
Subject: [PATCH] [STABLE] audit: remove superfluous new- prefix in AUDIT_LOGIN messages
Date: Tue, 17 Jun 2014 21:28:19 -0400
Message-Id: <ff92d27b675b6952d3df0c2459de1aeea8607502.1403054469.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new- prefix on ses and auid are un-necessary and break ausearch.

Upstream-commit: aa589a1
Cc: stable@vger.kernel.org # v3.14-rc1 to v3.14
Reported-by: Steve Grubb <sgrubb@redhat.com>
Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 37e6216..619b58d 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1991,7 +1991,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	if (!ab)
 		return;
 	audit_log_format(ab, "pid=%d uid=%u"
-			 " old-auid=%u new-auid=%u old-ses=%u new-ses=%u"
+			 " old-auid=%u auid=%u old-ses=%u ses=%u"
 			 " res=%d",
 			 current->pid, uid,
 			 oldloginuid, loginuid, oldsessionid, sessionid,
-- 
1.7.1

