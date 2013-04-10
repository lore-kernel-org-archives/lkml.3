Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936689Ab3DJJSN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 05:18:13 -0400
Received: from intranet.asianux.com ([58.214.24.6]:41647 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab3DJJSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 05:18:12 -0400
X-Spam-Score: -100.8
Message-ID: <51652E31.7090806@asianux.com>
Date: Wed, 10 Apr 2013 17:17:37 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Al Viro <viro@zeniv.linux.org.uk>, Jeff Layton <jlayton@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Serge Hallyn <serge.hallyn@canonical.com>
CC: "linux-kernel@vger.kernel.org >> \"linux-kernel@vger.kernel.org\"" 
	<linux-kernel@vger.kernel.org>
Subject: [PATCH] kernel: acct: kfree, also set related variable to NULL after
 kfree
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  after kfree acct, also set ns->bacct to NULL.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
---
 kernel/acct.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index 85389fe..91a23eb 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -332,6 +332,7 @@ void acct_exit_ns(struct pid_namespace *ns)
 	spin_lock(&acct_lock);
 	if (acct->file != NULL)
 		acct_file_reopen(acct, NULL, NULL);
+	ns->bacct = NULL;
 	spin_unlock(&acct_lock);
 
 	kfree(acct);
-- 
1.7.7.6
