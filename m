Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206Ab3EFXPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 19:15:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932672Ab3EFXOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 19:14:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: [ 103/104] rcutrace: single_open() leaks
Date: Mon,  6 May 2013 16:13:02 -0700
Message-Id: <20130506230054.196912722@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130506230043.526528358@linuxfoundation.org>
References: <20130506230043.526528358@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 7ee2b9e56495c56dcaffa2bab19b39451d9fdc8a upstream.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/rcutree_trace.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/kernel/rcutree_trace.c
+++ b/kernel/rcutree_trace.c
@@ -97,7 +97,7 @@ static const struct file_operations rcub
 	.open = rcubarrier_open,
 	.read = seq_read,
 	.llseek = no_llseek,
-	.release = seq_release,
+	.release = single_release,
 };
 
 #ifdef CONFIG_RCU_BOOST
@@ -208,7 +208,7 @@ static const struct file_operations rcue
 	.open = rcuexp_open,
 	.read = seq_read,
 	.llseek = no_llseek,
-	.release = seq_release,
+	.release = single_release,
 };
 
 #ifdef CONFIG_RCU_BOOST
@@ -308,7 +308,7 @@ static const struct file_operations rcuh
 	.open = rcuhier_open,
 	.read = seq_read,
 	.llseek = no_llseek,
-	.release = seq_release,
+	.release = single_release,
 };
 
 static void show_one_rcugp(struct seq_file *m, struct rcu_state *rsp)
@@ -350,7 +350,7 @@ static const struct file_operations rcug
 	.open = rcugp_open,
 	.read = seq_read,
 	.llseek = no_llseek,
-	.release = seq_release,
+	.release = single_release,
 };
 
 static void print_one_rcu_pending(struct seq_file *m, struct rcu_data *rdp)


