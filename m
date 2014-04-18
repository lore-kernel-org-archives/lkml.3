Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaDREgr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 00:36:47 -0400
Received: from mga01.intel.com ([192.55.52.88]:38154 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750830AbaDREgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 00:36:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,882,1389772800"; 
   d="scan'208";a="515151642"
From: Andi Kleen <andi@firstfloor.org>
To: mmarek@suse.cz
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Viresh Kumar <viresh.kumar@linaro.org>
Subject: [PATCH] Kbuild, lto: Avoid reported warning with strtoul
Date: Fri, 18 Apr 2014 06:35:56 +0200
Message-Id: <1397795756-23283-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Apparently someone's C library declares strtoul with warn_unused_result.
Cast to void to avoid the warning. Error handling is not useful here.

Cc: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 scripts/mod/modpost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/mod/modpost.c b/scripts/mod/modpost.c
index 0663556..b9cf439 100644
--- a/scripts/mod/modpost.c
+++ b/scripts/mod/modpost.c
@@ -1707,7 +1707,7 @@ static char *remove_dot(char *s)
 	int n = strcspn(s, ".");
 
 	if (n > 0 && s[n] != 0) {
-		strtoul(s + n + 1, &end, 10);
+		(void)strtoul(s + n + 1, &end, 10);
 		if  (end > s + n + 1 && (*end == '.' || *end == 0))
 			s[n] = 0;
 	}
-- 
1.8.5.2

