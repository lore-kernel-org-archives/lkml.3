Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab3JNUjx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:39:53 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38695 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932106Ab3JNUC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 075/161] perf completion: Use more comp words
Date: Mon, 14 Oct 2013 17:01:04 -0300
Message-Id: <1381780950-25642-76-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

The completion words $words and $cword are available, so we might as
well use them instead of directly accessing COMP_WORDS.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1372941691-14684-8-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index ee9c6d85f2c9..62e157db2e2b 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -92,15 +92,15 @@ __ltrim_colon_completions()
 type perf &>/dev/null &&
 _perf()
 {
-	local cur prev cmd
+	local cur words cword prev cmd
 
 	COMPREPLY=()
-	_get_comp_words_by_ref -n : cur prev
+	_get_comp_words_by_ref -n =: cur words cword prev
 
-	cmd=${COMP_WORDS[0]}
+	cmd=${words[0]}
 
 	# List perf subcommands or long options
-	if [ $COMP_CWORD -eq 1 ]; then
+	if [ $cword -eq 1 ]; then
 		if [[ $cur == --* ]]; then
 			COMPREPLY=( $( compgen -W '--help --version \
 			--exec-path --html-path --paginate --no-pager \
@@ -110,13 +110,13 @@ _perf()
 			COMPREPLY=( $( compgen -W '$cmds' -- "$cur" ) )
 		fi
 	# List possible events for -e option
-	elif [[ $prev == "-e" && "${COMP_WORDS[1]}" == @(record|stat|top) ]]; then
+	elif [[ $prev == "-e" && "${words[1]}" == @(record|stat|top) ]]; then
 		evts=$($cmd list --raw-dump)
 		COMPREPLY=( $( compgen -W '$evts' -- "$cur" ) )
 		__ltrim_colon_completions $cur
 	# List long option names
 	elif [[ $cur == --* ]];  then
-		subcmd=${COMP_WORDS[1]}
+		subcmd=${words[1]}
 		opts=$($cmd $subcmd --list-opts)
 		COMPREPLY=( $( compgen -W '$opts' -- "$cur" ) )
 	fi
-- 
1.8.1.4

