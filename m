Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755689Ab3KEVaV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:30:21 -0500
Received: from smtprelay0160.hostedemail.com ([216.40.44.160]:40702 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754892Ab3KEVaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:30:19 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::,RULES_HIT:41:355:379:541:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1373:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3876:3877:4321:5007:6114:6642:7652:10004:10400:10848:11026:11473:11658:11914:12043:12296:12438:12517:12519:12555:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flag07_28e026a38141
X-Filterd-Recvd-Size: 1942
Message-ID: <1383687018.4387.48.camel@joe-AO722>
Subject: [PATCH] signal/compat: save_altstack: Remove unnecessary semicolon
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>
Date: Tue, 05 Nov 2013 13:30:18 -0800
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

do { foo } while (0) macros don't need
a trailing semicolon.  Remove them.

Signed-off-by: Joe Perches <joe@perches.com>
---
 include/linux/compat.h | 2 +-
 include/linux/signal.h | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compat.h b/include/linux/compat.h
index 345da00..30c3a85 100644
--- a/include/linux/compat.h
+++ b/include/linux/compat.h
@@ -676,7 +676,7 @@ int __compat_save_altstack(compat_stack_t __user *, unsigned long);
 	put_user_ex(ptr_to_compat((void __user *)t->sas_ss_sp), &__uss->ss_sp); \
 	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
 	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
-} while (0);
+} while (0)
 
 asmlinkage long compat_sys_sched_rr_get_interval(compat_pid_t pid,
 						 struct compat_timespec __user *interval);
diff --git a/include/linux/signal.h b/include/linux/signal.h
index 2ac423b..ad934f6 100644
--- a/include/linux/signal.h
+++ b/include/linux/signal.h
@@ -440,7 +440,7 @@ int __save_altstack(stack_t __user *, unsigned long);
 	put_user_ex((void __user *)t->sas_ss_sp, &__uss->ss_sp); \
 	put_user_ex(sas_ss_flags(sp), &__uss->ss_flags); \
 	put_user_ex(t->sas_ss_size, &__uss->ss_size); \
-} while (0);
+} while (0)
 
 #ifdef CONFIG_PROC_FS
 struct seq_file;


