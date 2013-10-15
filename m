Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933160Ab3JOFry (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:47:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932411Ab3JOFXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:23:03 -0400
Date: Mon, 14 Oct 2013 22:22:51 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-30079d1d5ebcb8d706c6e05cacebb7facc60cd95@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        artagnon@gmail.com
In-Reply-To: <1372941691-14684-3-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-3-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Update __ltrim_colon_completions
Git-Commit-ID: 30079d1d5ebcb8d706c6e05cacebb7facc60cd95
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:22:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  30079d1d5ebcb8d706c6e05cacebb7facc60cd95
Gitweb:     http://git.kernel.org/tip/30079d1d5ebcb8d706c6e05cacebb7facc60cd95
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 4 Jul 2013 18:11:26 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:11:48 -0300

perf completion: Update __ltrim_colon_completions

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
index 50540cf..b0cdd12 100644
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
