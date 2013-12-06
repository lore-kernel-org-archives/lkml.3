Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757660Ab3LFMhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:37:18 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:41884 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753588Ab3LFMhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:37:16 -0500
From: Jeff Layton <jlayton@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] vfs: unexport the getname() symbol
Date: Fri,  6 Dec 2013 07:37:06 -0500
Message-Id: <1386333426-23579-1-git-send-email-jlayton@redhat.com>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leaving getname() exported when putname() isn't is a bad idea.

Signed-off-by: Jeff Layton <jlayton@redhat.com>
---
 fs/namei.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/namei.c b/fs/namei.c
index c53d3a9..83a456a 100644
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
1.8.4.2

