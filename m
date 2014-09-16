Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755435AbaIPUwT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:52:19 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:41538 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755323AbaIPUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:12 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Daniel Lezcano <daniel.lezcano@linaro.org>, linux-pm@vger.kernel.org
Subject: [PATCH 12/22] cpuidle: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:26 +0200
Message-Id: <1410900696-6481-13-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1410900696-6481-1-git-send-email-linux@rasmusvillemoes.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The kernel used to contain two functions for length-delimited,
case-insensitive string comparison, strnicmp with correct semantics
and a slightly buggy strncasecmp. The latter is the POSIX name, so
strnicmp was renamed to strncasecmp, and strnicmp made into a wrapper
for the new strncasecmp to avoid breaking existing users.

To allow the compat wrapper strnicmp to be removed at some point in
the future, and to avoid the extra indirection cost, do
s/strnicmp/strncasecmp/g.

Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/cpuidle/governor.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpuidle/governor.c b/drivers/cpuidle/governor.c
index ca89412..fb9f511 100644
--- a/drivers/cpuidle/governor.c
+++ b/drivers/cpuidle/governor.c
@@ -28,7 +28,7 @@ static struct cpuidle_governor * __cpuidle_find_governor(const char *str)
 	struct cpuidle_governor *gov;
 
 	list_for_each_entry(gov, &cpuidle_governors, governor_list)
-		if (!strnicmp(str, gov->name, CPUIDLE_NAME_LEN))
+		if (!strncasecmp(str, gov->name, CPUIDLE_NAME_LEN))
 			return gov;
 
 	return NULL;
-- 
2.0.4

