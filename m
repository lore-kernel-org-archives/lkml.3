Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094AbaKYLNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 06:13:06 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682AbaKYKme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:42:34 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 161/254] audit: AUDIT_FEATURE_CHANGE message format missing delimiting space
Date: Tue, 25 Nov 2014 10:38:31 +0000
Message-Id: <1416912004-5928-162-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit 897f1acbb6702ddaa953e8d8436eee3b12016c7e upstream.

Add a space between subj= and feature= fields to make them parsable.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/audit.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/audit.c b/kernel/audit.c
index ba2ff5a5c600..855aaa0803d9 100644
--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -739,7 +739,7 @@ static void audit_log_feature_change(int which, u32 old_feature, u32 new_feature
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_FEATURE_CHANGE);
 	audit_log_task_info(ab, current);
-	audit_log_format(ab, "feature=%s old=%u new=%u old_lock=%u new_lock=%u res=%d",
+	audit_log_format(ab, " feature=%s old=%u new=%u old_lock=%u new_lock=%u res=%d",
 			 audit_feature_names[which], !!old_feature, !!new_feature,
 			 !!old_lock, !!new_lock, res);
 	audit_log_end(ab);
-- 
2.1.0

