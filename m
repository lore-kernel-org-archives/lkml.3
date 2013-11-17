Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab3KQQWb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 11:22:31 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:58319 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab3KQQWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 11:22:20 -0500
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 1/5] perf completion: introduce a layer of indirection
Date: Sun, 17 Nov 2013 21:43:23 +0530
Message-Id: <1384704807-15779-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.5.rc0.6.gfd75b41
In-Reply-To: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the variables cur, words, cword, and prev outside the main
completion function so that we have a chance to override it when we
introduce zsh support.

Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 62e157db..3efdc84 100644
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
1.8.5.rc0.6.gfd75b41

