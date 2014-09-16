Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755566AbaIPUxq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 16:53:46 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:54241 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453AbaIPUwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 16:52:22 -0400
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Zhang Rui <rui.zhang@intel.com>,
        Eduardo Valentin <edubezval@gmail.com>, linux-pm@vger.kernel.org
Subject: [PATCH 21/22] Thermal: Replace strnicmp with strncasecmp
Date: Tue, 16 Sep 2014 22:51:35 +0200
Message-Id: <1410900696-6481-22-git-send-email-linux@rasmusvillemoes.dk>
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

Cc: Zhang Rui <rui.zhang@intel.com>
Cc: Eduardo Valentin <edubezval@gmail.com>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
---
 drivers/thermal/thermal_core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 71b0ec0..1e23f4f 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -66,7 +66,7 @@ static struct thermal_governor *__find_governor(const char *name)
 		return def_governor;
 
 	list_for_each_entry(pos, &thermal_governor_list, governor_list)
-		if (!strnicmp(name, pos->name, THERMAL_NAME_LENGTH))
+		if (!strncasecmp(name, pos->name, THERMAL_NAME_LENGTH))
 			return pos;
 
 	return NULL;
@@ -104,7 +104,7 @@ int thermal_register_governor(struct thermal_governor *governor)
 
 		name = pos->tzp->governor_name;
 
-		if (!strnicmp(name, governor->name, THERMAL_NAME_LENGTH))
+		if (!strncasecmp(name, governor->name, THERMAL_NAME_LENGTH))
 			pos->governor = governor;
 	}
 
@@ -129,7 +129,7 @@ void thermal_unregister_governor(struct thermal_governor *governor)
 	mutex_lock(&thermal_list_lock);
 
 	list_for_each_entry(pos, &thermal_tz_list, node) {
-		if (!strnicmp(pos->governor->name, governor->name,
+		if (!strncasecmp(pos->governor->name, governor->name,
 						THERMAL_NAME_LENGTH))
 			pos->governor = NULL;
 	}
@@ -1665,7 +1665,7 @@ struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name)
 
 	mutex_lock(&thermal_list_lock);
 	list_for_each_entry(pos, &thermal_tz_list, node)
-		if (!strnicmp(name, pos->type, THERMAL_NAME_LENGTH)) {
+		if (!strncasecmp(name, pos->type, THERMAL_NAME_LENGTH)) {
 			found++;
 			ref = pos;
 		}
-- 
2.0.4

