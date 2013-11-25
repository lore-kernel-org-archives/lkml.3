Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758175Ab3KYOYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 09:24:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42653 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757360Ab3KYOSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 09:18:01 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 04/25] perf completion: Introduce a layer of indirection
Date: Mon, 25 Nov 2013 11:17:34 -0300
Message-Id: <1385389075-7989-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385389075-7989-1-git-send-email-acme@infradead.org>
References: <1385389075-7989-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

Define the variables cur, words, cword, and prev outside the main
completion function so that we have a chance to override it when we
introduce zsh support.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1384704807-15779-2-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 62e157db2e2b..3efdc84f112c 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -89,15 +89,12 @@ __ltrim_colon_completions()
 	fi
 }
 
-type perf &>/dev/null &&
-_perf()
+__perf_main ()
 {
-	local cur words cword prev cmd
-
-	COMPREPLY=()
-	_get_comp_words_by_ref -n =: cur words cword prev
+	local cmd
 
 	cmd=${words[0]}
+	COMPREPLY=()
 
 	# List perf subcommands or long options
 	if [ $cword -eq 1 ]; then
@@ -120,6 +117,14 @@ _perf()
 		opts=$($cmd $subcmd --list-opts)
 		COMPREPLY=( $( compgen -W '$opts' -- "$cur" ) )
 	fi
+}
+
+type perf &>/dev/null &&
+_perf()
+{
+	local cur words cword prev
+	_get_comp_words_by_ref -n =: cur words cword prev
+	__perf_main
 } &&
 
 complete -o bashdefault -o default -o nospace -F _perf perf 2>/dev/null \
-- 
1.8.1.4

