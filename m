Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964789Ab3GDMpf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:45:35 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:55430 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932956Ab3GDMpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:31 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 2/7] perf completion: update __ltrim_colon_completions
Date: Thu,  4 Jul 2013 18:11:26 +0530
Message-Id: <1372941691-14684-3-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The function is taken from the bash-completion package; update it to use
the latest version where colon_word doesn't miss quoting.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
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
-- 
1.8.3.1.643.gebeea52.dirty

