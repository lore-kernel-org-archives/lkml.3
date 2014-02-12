Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520AbaBLIbz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 03:31:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50149 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaBLIN7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 03:13:59 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org,
        "Dominik Brodowski" <linux@dominikbrodowski.net>,
        "Josh Boyer" <jwboyer@redhat.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Josh Boyer" <jwboyer@fedoraproject.org>,
        "Thomas Renninger" <trenn@suse.de>
Date: Wed, 12 Feb 2014 08:10:12 +0000
Message-ID: <lsq.1392192612.821204399@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 51/79] cpupower: Fix segfault due to incorrect
 getopt_long arugments
In-Reply-To: <lsq.1392192611.998273004@decadent.org.uk>
X-SA-Exim-Connect-IP: 91.84.160.45
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.55-rc1 review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 tools/power/cpupower/utils/cpupower-set.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

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
 

