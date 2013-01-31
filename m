Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165Ab3AaLAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 06:00:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36320 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751336Ab3AaLAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 06:00:40 -0500
Date: Thu, 31 Jan 2013 03:00:17 -0800
From: tip-bot for Thomas Jarosch <thomas.jarosch@intra2net.com>
Message-ID: <tip-68c465ada54c730d653fc6fdc9dc0d5270b2de00@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, thomas.jarosch@intra2net.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, thomas.jarosch@intra2net.com, tglx@linutronix.de
In-Reply-To: <36736865.AIlztKhDqN@storm>
References: <36736865.AIlztKhDqN@storm>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix possible double free on error
Git-Commit-ID: 68c465ada54c730d653fc6fdc9dc0d5270b2de00
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Thu, 31 Jan 2013 03:00:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  68c465ada54c730d653fc6fdc9dc0d5270b2de00
Gitweb:     http://git.kernel.org/tip/68c465ada54c730d653fc6fdc9dc0d5270b2de00
Author:     Thomas Jarosch <thomas.jarosch@intra2net.com>
AuthorDate: Fri, 25 Jan 2013 10:57:08 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 30 Jan 2013 10:37:41 -0300

perf tools: Fix possible double free on error

Can only be triggered via CROSS_COMPILE env var.

Detected by cppcheck.

Signed-off-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
Link: http://lkml.kernel.org/r/36736865.AIlztKhDqN@storm
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/arch/common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 3e975cb..aacef07 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -155,6 +155,7 @@ static int perf_session_env__lookup_binutils_path(struct perf_session_env *env,
 		if (lookup_path(buf))
 			goto out;
 		free(buf);
+		buf = NULL;
 	}
 
 	if (!strcmp(arch, "arm"))
