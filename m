Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab3FKGaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 02:30:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab3FKG2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 02:28:47 -0400
Subject: Patch "ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section" has been added to the 3.0-stable tree
To: lizefan@huawei.com, fweisbec@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, namhyung@kernel.org,
        rostedt@goodmis.org, stable@vger.kernel.org
Cc: <stable@vger.kernel.org>, <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Mon, 10 Jun 2013 14:28:01 -0700
In-Reply-To: <51B1A150.6030804@huawei.com>
Message-ID: <13708996812812@kroah.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section

to the 3.0-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     ftrace-move-ftrace_filter_lseek-out-of-config_dynamic_ftrace-section.patch
and it can be found in the queue-3.0 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


>From lizefan@huawei.com  Mon Jun 10 14:16:48 2013
From: Li Zefan <lizefan@huawei.com>
Date: Fri, 7 Jun 2013 17:01:04 +0800
Subject: ftrace: Move ftrace_filter_lseek out of CONFIG_DYNAMIC_FTRACE section
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Namhyung Kim <namhyung@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>, Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Message-ID: <51B1A150.6030804@huawei.com>


From: Steven Rostedt <rostedt@goodmis.org>

commit 7f49ef69db6bbf756c0abca7e9b65b32e999eec8 upstream.

As ftrace_filter_lseek is now used with ftrace_pid_fops, it needs to
be moved out of the #ifdef CONFIG_DYNAMIC_FTRACE section as the
ftrace_pid_fops is defined when DYNAMIC_FTRACE is not.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Cc: Namhyung Kim <namhyung@kernel.org>
[ lizf: adjust context ]
Signed-off-by: Li Zefan <lizefan@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -933,6 +933,19 @@ static __init void ftrace_profile_debugf
 
 static struct pid * const ftrace_swapper_pid = &init_struct_pid;
 
+static loff_t
+ftrace_filter_lseek(struct file *file, loff_t offset, int whence)
+{
+	loff_t ret;
+
+	if (file->f_mode & FMODE_READ)
+		ret = seq_lseek(file, offset, whence);
+	else
+		file->f_pos = ret = 1;
+
+	return ret;
+}
+
 #ifdef CONFIG_DYNAMIC_FTRACE
 
 #ifndef CONFIG_FTRACE_MCOUNT_RECORD
@@ -2299,19 +2312,6 @@ ftrace_notrace_open(struct inode *inode,
 				 inode, file);
 }
 
-static loff_t
-ftrace_filter_lseek(struct file *file, loff_t offset, int origin)
-{
-	loff_t ret;
-
-	if (file->f_mode & FMODE_READ)
-		ret = seq_lseek(file, offset, origin);
-	else
-		file->f_pos = ret = 1;
-
-	return ret;
-}
-
 static int ftrace_match(char *str, char *regex, int len, int type)
 {
 	int matched = 0;


Patches currently in stable-queue which might be from lizefan@huawei.com are

queue-3.0/tracing-fix-possible-null-pointer-dereferences.patch
queue-3.0/ftrace-move-ftrace_filter_lseek-out-of-config_dynamic_ftrace-section.patch
