Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaA0Sdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 13:33:42 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:53450 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869AbaA0Sdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 13:33:40 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH][resend] vfs: unexport the getname() symbol
Date: Mon, 27 Jan 2014 13:33:28 -0500
Message-Id: <1390847608-16146-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1386333426-23579-1-git-send-email-jlayton@redhat.com>
References: <1386333426-23579-1-git-send-email-jlayton@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leaving getname() exported when putname() isn't is a bad idea.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index 3531dee..46dbd31 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -209,7 +209,6 @@ getname(const char __user * filename)
 {
 	return getname_flags(filename, 0, NULL);
 }
-EXPORT_SYMBOL(getname);
 
 #ifdef CONFIG_AUDITSYSCALL
 void putname(struct filename *name)
-- 
1.8.5.3

