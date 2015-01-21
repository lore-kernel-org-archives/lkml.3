Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898AbbAUSb7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:31:59 -0500
Received: from smtprelay0152.hostedemail.com ([216.40.44.152]:33830 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753819AbbAUSbw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:31:52 -0500
X-Session-Marker: 6E657665747340676F6F646D69732E6F7267
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,rostedt@goodmis.org,:::::::::,RULES_HIT:41:355:379:541:599:968:988:989:1260:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1539:1568:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2895:3138:3139:3140:3141:3142:3865:3867:5007:6261:7875:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12555:13069:13161:13229:13311:13357:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: quill09_101b594e75f09
X-Filterd-Recvd-Size: 1711
Date: Wed, 21 Jan 2015 13:31:49 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 4/5] tracing: Have mkdir and rmdir be part of
 tracefs
Message-ID: <20150121133149.4a4dac04@gandalf.local.home>
In-Reply-To: <20150121172101.953700301@goodmis.org>
References: <20150121171953.823177070@goodmis.org>
	<20150121172101.953700301@goodmis.org>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The update to the missing tracefs.h.

-- Steve

---
 include/linux/tracefs.h |   8 ++++

diff --git a/include/linux/tracefs.h b/include/linux/tracefs.h
index 23e04ce21749..f8c58ab18bca 100644
--- a/include/linux/tracefs.h
+++ b/include/linux/tracefs.h
@@ -34,6 +34,14 @@ struct dentry *tracefs_create_dir(const char *name, struct dentry *parent);
 void tracefs_remove(struct dentry *dentry);
 void tracefs_remove_recursive(struct dentry *dentry);
 
+struct tracefs_dir_ops {
+	int (*mkdir)(const char *name);
+	int (*rmdir)(const char *name);
+	struct task_struct *lock_owner;
+};
+
+void tracefs_add_dir_ops(struct dentry *dentry, struct tracefs_dir_ops *ops);
+
 bool tracefs_initialized(void);
 
 #endif /* CONFIG_TRACING */
