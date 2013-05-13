Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3EMCQ7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 May 2013 22:16:59 -0400
Received: from intranet.asianux.com ([58.214.24.6]:38428 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200Ab3EMCQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 May 2013 22:16:58 -0400
X-Spam-Score: -100.8
Message-ID: <51904CE7.8080504@asianux.com>
Date: Mon, 13 May 2013 10:16:07 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Layton <jlayton@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH v2] kernel/acct.c: cleanup, also better to set related variable
 to NULL after kfree
References: <518CC9E3.1060304@asianux.com> <20130510074809.0e930a28@corrin.poochiereds.net> <518D02A0.1080306@asianux.com> <518D2004.8070400@asianux.com>
In-Reply-To: <518D2004.8070400@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After kfree acct, also better to set ns->bacct to NULL.

Currently, it is as a cleanup patch.


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
