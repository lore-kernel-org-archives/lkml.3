Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753141AbaAMOt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 09:49:58 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:51378 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751926AbaAMO0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 09:26:08 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 45/96] cpupower: Fix segfault due to incorrect getopt_long arugments
Date: Mon, 13 Jan 2014 14:24:08 +0000
Message-Id: <1389623099-18783-46-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
References: <1389623099-18783-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.29 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Boyer <jwboyer@redhat.com>

commit f447ef4a56dee4b68a91460bcdfe06b5011085f2 upstream.

If a user calls 'cpupower set --perf-bias 15', the process will end with
a SIGSEGV in libc because cpupower-set passes a NULL optarg to the atoi
call.  This is because the getopt_long structure currently has all of
the options as having an optional_argument when they really have a
required argument.  We change the structure to use required_argument to
match the short options and it resolves the issue.

This fixes https://bugzilla.redhat.com/show_bug.cgi?id=1000439

Signed-off-by: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Thomas Renninger <trenn@suse.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
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
1.8.3.2

