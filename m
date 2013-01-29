Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754622Ab3A2TIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 14:08:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2100 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754157Ab3A2TIE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 14:08:04 -0500
Message-Id: <20130129190759.857103871@napanee.usersys.redhat.com>
User-Agent: quilt/0.48-1
Date: Tue, 29 Jan 2013 14:08:03 -0500
From: aris@redhat.com
To: linux-kernel@vger.kernel.org
Cc: cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>
Subject: [PATCH v3 4/9] devcg: expand may_access() logic
References: <20130129190759.117458287@napanee.usersys.redhat.com>
Content-Disposition: inline; filename=split_may_access_logic.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to make the next patch more clear, expand may_access() logic.

Cc: Tejun Heo <tj@kernel.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Signed-off-by: Aristeu Rozanski <aris@redhat.com>

---
 security/device_cgroup.c |   15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

--- github.orig/security/device_cgroup.c	2013-01-29 11:49:15.244665037 -0500
+++ github/security/device_cgroup.c	2013-01-29 11:49:15.514669057 -0500
@@ -382,15 +382,18 @@ 		if (ex->minor != ~0 && ex->minor != re
 
 	/*
 	 * In two cases we'll consider this new exception valid:
-	 * - the dev cgroup has its default policy to allow + exception list:
-	 *   the new exception should *not* match any of the exceptions
-	 *   (behavior == DEVCG_DEFAULT_ALLOW, !match)
 	 * - the dev cgroup has its default policy to deny + exception list:
 	 *   the new exception *should* match the exceptions
-	 *   (behavior == DEVCG_DEFAULT_DENY, match)
+	 * - the dev cgroup has its default policy to allow + exception list:
+	 *   the new exception should *not* match any of the exceptions
 	 */
-	if ((dev_cgroup->behavior == DEVCG_DEFAULT_DENY) == match)
-		return 1;
+	if (dev_cgroup->behavior == DEVCG_DEFAULT_DENY) {
+		if (match)
+			return 1;
+	} else {
+		if (!match)
+			return 1;
+	}
 	return 0;
 }
 

