Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703Ab3JOFrJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:47:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32875 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932782Ab3JOFXM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:23:12 -0400
Date: Mon, 14 Oct 2013 22:23:00 -0700
From: tip-bot for Ramkumar Ramachandra <tipbot@zytor.com>
Message-ID: <tip-7b6c48e16e5d312b0ebae78acfb3ff4f9c8c083c@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, fweisbec@gmail.com, artagnon@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, fweisbec@gmail.com, tglx@linutronix.de,
        artagnon@gmail.com
In-Reply-To: <1372941691-14684-4-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-4-git-send-email-artagnon@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf completion: Strip dependency on _filedir
Git-Commit-ID: 7b6c48e16e5d312b0ebae78acfb3ff4f9c8c083c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:23:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7b6c48e16e5d312b0ebae78acfb3ff4f9c8c083c
Gitweb:     http://git.kernel.org/tip/7b6c48e16e5d312b0ebae78acfb3ff4f9c8c083c
Author:     Ramkumar Ramachandra <artagnon@gmail.com>
AuthorDate: Thu, 4 Jul 2013 18:11:27 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:11:55 -0300

perf completion: Strip dependency on _filedir

_filedir is defined in the bash-completion package, but there is no need
to depend on it.  Instead, call complete with multiple -o arguments
before the -F argument like in git.git's completion script.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1372941691-14684-4-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index b0cdd12..d2598be 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -54,9 +54,8 @@ _perf()
 		subcmd=${COMP_WORDS[1]}
 		opts=$($cmd $subcmd --list-opts)
 		COMPREPLY=( $( compgen -W '$opts' -- "$cur" ) )
-	# Fall down to list regular files
-	else
-		_filedir
 	fi
 } &&
-complete -F _perf perf
+
+complete -o bashdefault -o default -o nospace -F _perf perf 2>/dev/null \
+	|| complete -o default -o nospace -F _perf perf
