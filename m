Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752204Ab3K3Mt4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 07:49:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59495 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637Ab3K3Mtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 07:49:52 -0500
Date: Sat, 30 Nov 2013 04:49:38 -0800
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-2cf025e69543f5f4aa68e8549d60680515fef5ad@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, artagnon@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, artagnon@gmail.com
In-Reply-To: <1384704807-15779-2-git-send-email-artagnon@gmail.com>
References: <1384704807-15779-2-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Introduce a layer of indirection
Git-Commit-ID: 2cf025e69543f5f4aa68e8549d60680515fef5ad
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Sat, 30 Nov 2013 04:49:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2cf025e69543f5f4aa68e8549d60680515fef5ad
Gitweb:     http://git.kernel.org/tip/2cf025e69543f5f4aa68e8549d60680515fef5ad
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Sun, 17 Nov 2013 21:43:23 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 27 Nov 2013 14:58:35 -0300

perf completion: Introduce a layer of indirection

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
