Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755218AbaEVMYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 08:24:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51061 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754940AbaEVMYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 08:24:40 -0400
Date: Thu, 22 May 2014 05:24:27 -0700
From: tip-bot for Michael Lentine <tipbot@zytor.com>
Message-ID: <tip-21cfc5e10395eba795c0610cf3cf7f0a4f6f33ff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, mlentine@google.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, mlentine@google.com, jolsa@kernel.org,
        tglx@linutronix.de
In-Reply-To: <1400579330-5043-2-git-send-email-eranian@google.com>
References: <1400579330-5043-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add cat as fallback pager
Git-Commit-ID: 21cfc5e10395eba795c0610cf3cf7f0a4f6f33ff
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  21cfc5e10395eba795c0610cf3cf7f0a4f6f33ff
Gitweb:     http://git.kernel.org/tip/21cfc5e10395eba795c0610cf3cf7f0a4f6f33ff
Author:     Michael Lentine <mlentine@google.com>
AuthorDate: Tue, 20 May 2014 11:48:49 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 21 May 2014 11:48:33 +0200

perf tools: Add cat as fallback pager

This patch adds a fallback to cat for the pager. This is useful
on environments, such as Android, where less does not exist.
It is better to default to cat than to abort.

Signed-off-by: Michael Lentine <mlentine@google.com>
Reviewed-by: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1400579330-5043-2-git-send-email-eranian@google.com
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/pager.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/util/pager.c b/tools/perf/util/pager.c
index 3322b84..31ee02d 100644
--- a/tools/perf/util/pager.c
+++ b/tools/perf/util/pager.c
@@ -57,13 +57,13 @@ void setup_pager(void)
 	}
 	if (!pager)
 		pager = getenv("PAGER");
-	if (!pager) {
-		if (!access("/usr/bin/pager", X_OK))
-			pager = "/usr/bin/pager";
-	}
+	if (!(pager || access("/usr/bin/pager", X_OK)))
+		pager = "/usr/bin/pager";
+	if (!(pager || access("/usr/bin/less", X_OK)))
+		pager = "/usr/bin/less";
 	if (!pager)
-		pager = "less";
-	else if (!*pager || !strcmp(pager, "cat"))
+		pager = "cat";
+	if (!*pager || !strcmp(pager, "cat"))
 		return;
 
 	spawned_pager = 1; /* means we are emitting to terminal */
