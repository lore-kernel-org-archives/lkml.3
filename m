Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932865Ab3JOFXn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:23:43 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32902 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932605Ab3JOFXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:23:39 -0400
Date: Mon, 14 Oct 2013 22:23:27 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-6e0dc374a2c912a8a967ea8a4f9696dd4b0a6d3e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        artagnon@gmail.com
In-Reply-To: <1372941691-14684-8-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-8-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Use more comp words
Git-Commit-ID: 6e0dc374a2c912a8a967ea8a4f9696dd4b0a6d3e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:23:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6e0dc374a2c912a8a967ea8a4f9696dd4b0a6d3e
Gitweb:     http://git.kernel.org/tip/6e0dc374a2c912a8a967ea8a4f9696dd4b0a6d3e
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 4 Jul 2013 18:11:31 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:12:31 -0300

perf completion: Use more comp words

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
index ee9c6d8..62e157db 100644
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
