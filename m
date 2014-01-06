Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933760AbaAFXX7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 18:23:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48221 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898AbaAFWlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 17:41:01 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 3.10 060/129] cpupower: Fix segfault due to incorrect getopt_long arugments
Date: Mon,  6 Jan 2014 14:38:09 -0800
Message-Id: <20140106223901.319245458@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
References: <20140106223859.589799655@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/power/cpupower/utils/cpupower-set.c |    6 +++---
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
 


