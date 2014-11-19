Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362AbaKSWR5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 17:17:57 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56106 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932625AbaKSUyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:15 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Richard Guy Briggs <rgb@redhat.com>, Paul Moore <pmoore@redhat.com>
Subject: [PATCH 3.17 045/141] audit: AUDIT_FEATURE_CHANGE message format missing delimiting space
Date: Wed, 19 Nov 2014 12:51:08 -0800
Message-Id: <20141119205152.148547119@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Guy Briggs <rgb@redhat.com>

commit 897f1acbb6702ddaa953e8d8436eee3b12016c7e upstream.

Add a space between subj= and feature= fields to make them parsable.

Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
Signed-off-by: Paul Moore <pmoore@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/audit.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/audit.c
+++ b/kernel/audit.c
@@ -739,7 +739,7 @@ static void audit_log_feature_change(int
 
 	ab = audit_log_start(NULL, GFP_KERNEL, AUDIT_FEATURE_CHANGE);
 	audit_log_task_info(ab, current);
-	audit_log_format(ab, "feature=%s old=%u new=%u old_lock=%u new_lock=%u res=%d",
+	audit_log_format(ab, " feature=%s old=%u new=%u old_lock=%u new_lock=%u res=%d",
 			 audit_feature_names[which], !!old_feature, !!new_feature,
 			 !!old_lock, !!new_lock, res);
 	audit_log_end(ab);


