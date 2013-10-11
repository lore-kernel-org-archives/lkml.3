Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757752Ab3JKMqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 08:46:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8995 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab3JKMqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 08:46:02 -0400
Date: Fri, 11 Oct 2013 08:45:51 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] cpupower: Fix segfault due to incorrect getopt_long arugments
Message-ID: <20131011124551.GF2917@hansolo.jdub.homelinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a user calls 'cpupower set --perf-bias 15', the process will end with a
SIGSEGV in libc because cpupower-set passes a NULL optarg to the atoi call.
This is because the getopt_long structure currently has all of the options
as having an optional_argument when they really have a required argument.
We change the structure to use required_argument to match the short options
and it resolves the issue.

This fixes https://bugzilla.redhat.com/show_bug.cgi?id=1000439

Cc: stable@vger.kernel.org
Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
---
 tools/power/cpupower/utils/cpupower-set.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/power/cpupower/utils/cpupower-set.c b/tools/power/cpupower/utils/cpupower-set.c
index dc4de37..bcf1d2f 100644
--- a/tools/power/cpupower/utils/cpupower-set.c
+++ b/tools/power/cpupower/utils/cpupower-set.c
@@ -18,9 +18,9 @@
 #include "helpers/bitmask.h"
 
 static struct option set_opts[] = {
-	{ .name = "perf-bias",	.has_arg = optional_argument,	.flag = NULL,	.val = 'b'},
-	{ .name = "sched-mc",	.has_arg = optional_argument,	.flag = NULL,	.val = 'm'},
-	{ .name = "sched-smt",	.has_arg = optional_argument,	.flag = NULL,	.val = 's'},
+	{ .name = "perf-bias",	.has_arg = required_argument,	.flag = NULL,	.val = 'b'},
+	{ .name = "sched-mc",	.has_arg = required_argument,	.flag = NULL,	.val = 'm'},
+	{ .name = "sched-smt",	.has_arg = required_argument,	.flag = NULL,	.val = 's'},
 	{ },
 };
 
-- 
1.8.3.1

