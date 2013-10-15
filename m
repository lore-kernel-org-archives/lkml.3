Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932826Ab3JOFXY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:23:24 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32885 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932780Ab3JOFXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:23:20 -0400
Date: Mon, 14 Oct 2013 22:23:08 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-4685a6cfaeac6d2fe8ed10a9aa0cbff5026529cb@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        artagnon@gmail.com
In-Reply-To: <1372941691-14684-6-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-6-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Strip function_exists ()
Git-Commit-ID: 4685a6cfaeac6d2fe8ed10a9aa0cbff5026529cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:23:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4685a6cfaeac6d2fe8ed10a9aa0cbff5026529cb
Gitweb:     http://git.kernel.org/tip/4685a6cfaeac6d2fe8ed10a9aa0cbff5026529cb
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 4 Jul 2013 18:11:29 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:12:06 -0300

perf completion: Strip function_exists ()

Use "type" to check existence consistently.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1372941691-14684-6-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index d2598be..35fdda1 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -1,12 +1,6 @@
 # perf completion
 
-function_exists()
-{
-	declare -F $1 > /dev/null
-	return $?
-}
-
-function_exists __ltrim_colon_completions ||
+type __ltrim_colon_completions &>/dev/null ||
 __ltrim_colon_completions()
 {
 	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
