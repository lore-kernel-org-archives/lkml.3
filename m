Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933315Ab3JNUku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:40:50 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38612 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3JNUCz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:02:55 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ramkumar Ramachandra <artagnon@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 070/161] perf completion: Don't dictate perf install location
Date: Mon, 14 Oct 2013 17:00:59 -0300
Message-Id: <1381780950-25642-71-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ramkumar Ramachandra <artagnon@gmail.com>

The statement

  have perf

limits the locations in which to look for the perf program.  Moreover,
it depends on the bash-completion package to be installed.  Replace it
with a call to `type perf`.

Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1372941691-14684-2-git-send-email-artagnon@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/bash_completion | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 56e6a12aab59..50540cfe3d18 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -19,7 +19,7 @@ __ltrim_colon_completions()
 	fi
 }
 
-have perf &&
+type perf &>/dev/null &&
 _perf()
 {
 	local cur prev cmd
-- 
1.8.1.4

