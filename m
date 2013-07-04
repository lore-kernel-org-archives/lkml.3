Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964891Ab3GDMpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:45:41 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:33081 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756688Ab3GDMpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:34 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 3/7] perf completion: strip dependency on _filedir
Date: Thu,  4 Jul 2013 18:11:27 +0530
Message-Id: <1372941691-14684-4-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

_filedir is defined in the bash-completion package, but there is no need
to depend on it.  Instead, call complete with multiple -o arguments
before the -F argument like in git.git's completion script.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
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
-- 
1.8.3.1.643.gebeea52.dirty

