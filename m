Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934810Ab3DHD1k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Apr 2013 23:27:40 -0400
Received: from intranet.asianux.com ([58.214.24.6]:6683 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934604Ab3DHD1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Apr 2013 23:27:38 -0400
X-Spam-Score: -100.8
Message-ID: <5162390C.5060804@asianux.com>
Date: Mon, 08 Apr 2013 11:27:08 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: tsacct: strncpy, always be sure of NUL terminated.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  for NUL terminated string, always set '\0' at the end.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/tsacct.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/kernel/tsacct.c b/kernel/tsacct.c
index a1dd9a1..01bcc4e 100644
--- a/kernel/tsacct.c
+++ b/kernel/tsacct.c
@@ -78,7 +78,8 @@ void bacct_add_tsk(struct user_namespace *user_ns,
 	stats->ac_minflt = tsk->min_flt;
 	stats->ac_majflt = tsk->maj_flt;
 
-	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm));
+	strncpy(stats->ac_comm, tsk->comm, sizeof(stats->ac_comm) - 1);
+	stats->ac_comm[sizeof(stats->ac_comm) - 1] = '\0';
 }
 
 
-- 
1.7.7.6
