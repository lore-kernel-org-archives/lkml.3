Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933334Ab3JNUlq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:41:46 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38606 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab3JNUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 071/161] perf completion: Update __ltrim_colon_completions
Date: Mon, 14 Oct 2013 17:01:00 -0300
Message-Id: <1381780950-25642-72-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

The function is taken from the bash-completion package; update it to use
the latest version where colon_word doesn't miss quoting.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1372941691-14684-3-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 50540cfe3d18..b0cdd12bd5e4 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -11,7 +11,7 @@ __ltrim_colon_completions()
 {
 	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
 		# Remove colon-word prefix from COMPREPLY items
-		local colon_word=${1%${1##*:}}
+		local colon_word=${1%"${1##*:}"}
 		local i=${#COMPREPLY[*]}
 		while [[ $((--i)) -ge 0 ]]; do
 			COMPREPLY[$i]=${COMPREPLY[$i]#"$colon_word"}
-- 
1.8.1.4

