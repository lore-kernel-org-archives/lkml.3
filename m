Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754297AbaGPVUl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 17:20:41 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:36940 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaGPVUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 17:20:34 -0400
Date: Thu, 17 Jul 2014 00:20:29 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] proc: more "const char *" pointers
Message-ID: <20140716212027.GA21242@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 fs/proc/base.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -105,7 +105,7 @@
  */
 
 struct pid_entry {
-	char *name;
+	const char *name;
 	int len;
 	umode_t mode;
 	const struct inode_operations *iop;
@@ -418,8 +418,8 @@ static int proc_oom_score(struct task_struct *task, char *buffer)
 }
 
 struct limit_names {
-	char *name;
-	char *unit;
+	const char *name;
+	const char *unit;
 };
 
 static const struct limit_names lnames[RLIM_NLIMITS] = {
@@ -2056,7 +2056,7 @@ static int show_timer(struct seq_file *m, void *v)
 	struct k_itimer *timer;
 	struct timers_private *tp = m->private;
 	int notify;
-	static char *nstr[] = {
+	static const char * const nstr[] = {
 		[SIGEV_SIGNAL] = "signal",
 		[SIGEV_NONE] = "none",
 		[SIGEV_THREAD] = "thread",
