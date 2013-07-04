Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964951Ab3GDMpw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:45:52 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:63114 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964901Ab3GDMpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:46 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 7/7] perf completion: use more comp words
Date: Thu,  4 Jul 2013 18:11:31 +0530
Message-Id: <1372941691-14684-8-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The completion words $words and $cword are available, so we might as
well use them instead of directly accessing COMP_WORDS.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 765fb2f..9bb5f4d 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -92,15 +92,15 @@ __ltrim_colon_completions ()
 type perf &>/dev/null &&
 _perf ()
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
@@ -110,13 +110,13 @@ _perf ()
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
1.8.3.1.643.gebeea52.dirty

