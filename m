Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132AbaGPUDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:03:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27051 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751890AbaGPUDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:14 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 06/13] perf tools: Allow events with dot
Date: Wed, 16 Jul 2014 22:02:42 +0200
Message-Id: <1405540969-18975-7-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

The Intel events use a dot to separate event name and unit mask.
Allow dot in names in the scanner, and remove special handling
of dot as EOF. Also remove the hack in jevents to replace dot
with underscore. This way dotted events can be specified
directly by the user.

I'm not fully sure this change to the scanner is correct
(what was the dot special case good for?), but I haven't
found anything that breaks with it so far at least.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1405123165-22666-5-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/parse-events.l | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 343299575b30..709fa3b57e83 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -81,7 +81,7 @@ num_dec		[0-9]+
 num_hex		0x[a-fA-F0-9]+
 num_raw_hex	[a-fA-F0-9]+
 name		[a-zA-Z_*?][a-zA-Z0-9_*?]*
-name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?]*
+name_minus	[a-zA-Z_*?][a-zA-Z0-9\-_*?.]*
 /* If you add a modifier you need to update check_modifier() */
 modifier_event	[ukhpGHSD]+
 modifier_bp	[rwx]{1,3}
@@ -119,7 +119,6 @@ modifier_bp	[rwx]{1,3}
 			return PE_EVENT_NAME;
 		}
 
-.		|
 <<EOF>>		{
 			BEGIN(INITIAL); yyless(0);
 		}
-- 
1.8.3.1

