Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967128AbaFTSmi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 14:42:38 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:36987 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966270AbaFTSmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 14:42:37 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH] trace-cmd: Add missing mode to open() call
Date: Fri, 20 Jun 2014 13:42:29 -0500
Message-Id: <1403289749-1631-1-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

touch_file() calls open(2) with O_CREAT but omits the required
mode argument. Fix this omission.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 trace-record.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/trace-record.c b/trace-record.c
index d3dd0c5..8438388 100644
--- a/trace-record.c
+++ b/trace-record.c
@@ -1995,7 +1995,7 @@ static void touch_file(const char *file)
 {
 	int fd;
 
-	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC);
+	fd = open(file, O_WRONLY | O_CREAT | O_TRUNC, 0644);
 	if (fd < 0)
 		die("could not create file %s\n", file);
 	close(fd);
-- 
1.9.1

