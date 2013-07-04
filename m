Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965042Ab3GDMrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 08:47:35 -0400
Received: from mail-pb0-f52.google.com ([209.85.160.52]:39513 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964852Ab3GDMpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 08:45:39 -0400
From: Ramkumar Ramachandra <artagnon@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 5/7] perf completion: strip function_exists ()
Date: Thu,  4 Jul 2013 18:11:29 +0530
Message-Id: <1372941691-14684-6-git-send-email-artagnon@gmail.com>
X-Mailer: git-send-email 1.8.3.1.643.gebeea52.dirty
In-Reply-To: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
References: <1372941691-14684-1-git-send-email-artagnon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use "type" to check existence consistently.

Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Ramkumar Ramachandra <artagnon@gmail.com>
---
 tools/perf/bash_completion | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/tools/perf/bash_completion b/tools/perf/bash_completion
index 8c04f5d..852d444 100644
--- a/tools/perf/bash_completion
+++ b/tools/perf/bash_completion
@@ -1,12 +1,6 @@
 # perf completion
 
-function_exists()
-{
-	declare -F $1 > /dev/null
-	return $?
-}
-
-function_exists __ltrim_colon_completions ||
+type __ltrim_colon_completions &>/dev/null ||
 __ltrim_colon_completions ()
 {
 	if [[ "$1" == *:* && "$COMP_WORDBREAKS" == *:* ]]; then
-- 
1.8.3.1.643.gebeea52.dirty

