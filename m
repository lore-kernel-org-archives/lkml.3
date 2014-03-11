Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680AbaCKT7s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 15:59:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55430 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327AbaCKT7K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 15:59:10 -0400
From: Richard Guy Briggs <rgb@redhat.com>
To: linux-audit@redhat.com, linux-kernel@vger.kernel.org
Cc: Richard Guy Briggs <rgb@redhat.com>, eparis@redhat.com, sgrubb@redhat.com
Subject: [PATCH 1/2] audit: remove superfluous new- prefix in AUDIT_LOGIN messages
Date: Tue, 11 Mar 2014 15:58:22 -0400
Message-Id: <ebfca97e5d32fc1edf604b2a3137c18a0b13dba0.1394567663.git.rgb@redhat.com>
In-Reply-To: <cover.1394567663.git.rgb@redhat.com>
References: <cover.1394567663.git.rgb@redhat.com>
In-Reply-To: <cover.1394567663.git.rgb@redhat.com>
References: <cover.1394567663.git.rgb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The new- prefix on ses and auid are un-necessary and break ausearch.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
---
 kernel/auditsc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index eb01d47..3bc12d2 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1984,7 +1984,7 @@ static void audit_log_set_loginuid(kuid_t koldloginuid, kuid_t kloginuid,
 	if (!ab)
 		return;
 	audit_log_format(ab, "pid=%d uid=%u"
-			 " old-auid=%u new-auid=%u old-ses=%u new-ses=%u"
+			 " old-auid=%u auid=%u old-ses=%u ses=%u"
 			 " res=%d",
 			 task_pid_nr(current), uid,
 			 oldloginuid, loginuid, oldsessionid, sessionid,
-- 
1.7.1

