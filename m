Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352Ab3JNUmT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:42:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38602 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757551Ab3JNUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:54 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 072/161] perf completion: Strip dependency on _filedir
Date: Mon, 14 Oct 2013 17:01:01 -0300
Message-Id: <1381780950-25642-73-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

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
index b0cdd12bd5e4..d2598be517fb 100644
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
-- 
1.8.1.4

