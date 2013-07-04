Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab3GDMsw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:48:52 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:55346 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932221Ab3GDMp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:29 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 1/7] perf completion: don't dictate perf install location
Date: Thu,  4 Jul 2013 18:11:25 +0530
Message-Id: <1372941691-14684-2-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The statement

  have perf

limits the locations in which to look for the perf program.  Moreover,
it depends on the bash-completion package to be installed.  Replace it
with a call to `type perf`.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 56e6a12..50540cf 100644
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
1.8.3.1.643.gebeea52.dirty

