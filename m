Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaLUDjQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 22:39:16 -0500
Received: from mail-pd0-f182.google.com ([209.85.192.182]:63726 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752812AbaLUDjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 22:39:14 -0500
From: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
To: akpm@linux-foundation.org, oleg@redhat.com, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org,
        Gangadhar Vukkesala <gangs.freelancer@gmail.com>
Subject: [PATCH] kernel: removed unnecessary initialization of static variable
Date: Sun, 21 Dec 2014 09:09:05 +0530
Message-Id: <1419133145-5137-1-git-send-email-gangs.freelancer@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed unnecessary initialization of static variable "zero" to 0 
in pid_namespace.c as default value of static variable is 0.
This issue was found when running checkpatch.pl script on pid_namespace.c.

Signed-off-by: Gangadhar Vukkesala <gangs.freelancer@gmail.com>
---
 kernel/pid_namespace.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index a65ba13..f21eb3f 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -290,7 +290,7 @@ static int pid_ns_ctl_handler(struct ctl_table *table, int write,
 }
 
 extern int pid_max;
-static int zero = 0;
+static int zero;
 static struct ctl_table pid_ns_ctl_table[] = {
 	{
 		.procname = "ns_last_pid",
-- 
Gangadhar Vukkesala

