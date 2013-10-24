Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756201Ab3JXTOp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:14:45 -0400
Received: from mail-oa0-f52.google.com ([209.85.219.52]:51544 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756096Ab3JXTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:14:43 -0400
From: Seth Forshee <seth.forshee@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Seth Forshee <seth.forshee@canonical.com>
Subject: [PATCH trace-cmd 1/5] trace-cmd/listen: Remove use of sighandler_t
Date: Thu, 24 Oct 2013 14:14:30 -0500
Message-Id: <1382642074-15567-2-git-send-email-seth.forshee@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
References: <1382642074-15567-1-git-send-email-seth.forshee@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

sighandler_t is a GNU extension and may not be defined if
_GNU_SOURCE is not set. To minimize the potential for build
problems, change signal_setup() to declare its handle argument
the same way struct sigaction declares the sa_handler member.

Signed-off-by: Seth Forshee <seth.forshee@canonical.com>
---
 trace-listen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/trace-listen.c b/trace-listen.c
index 8b8f02c..0019089 100644
--- a/trace-listen.c
+++ b/trace-listen.c
@@ -69,7 +69,7 @@ static void put_temp_file(char *file)
 
 #define MAX_PATH 1024
 
-static void signal_setup(int sig, sighandler_t handle)
+static void signal_setup(int sig, void (*handle)(int))
 {
 	struct sigaction action;
 
-- 
1.8.3.2

