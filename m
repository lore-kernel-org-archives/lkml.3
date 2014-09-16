Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbaIPHzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 03:55:00 -0400
Received: from smtprelay0086.hostedemail.com ([216.40.44.86]:35327 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752150AbaIPHy7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 03:54:59 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3350:3622:3865:3870:3871:3872:3873:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12114:12296:12438:12517:12519:12555:12740:13069:13255:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: show40_e20887de032a
X-Filterd-Recvd-Size: 1700
Message-ID: <1410854092.18787.43.camel@joe-AO725>
Subject: Re: [PATCH] staging: dgap: use schedule_timeout_interruptible()
 instead of dgap_ms_sleep()
From: Joe Perches <joe@perches.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Daeseok Youn <daeseok.youn@gmail.com>, lidza.louina@gmail.com,
        markh@compro.net, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, driverdev-devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Date: Tue, 16 Sep 2014 00:54:52 -0700
In-Reply-To: <20140916063115.GF17875@mwanda>
References: <20140916033333.GA26821@devel> <20140916063115.GF17875@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-09-16 at 09:31 +0300, Dan Carpenter wrote:
> There is no point in calling signal_pending() if you don't care about
> the return value.

So maybe make it __must_check?
---
 include/linux/sched.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 7d799ea..03273c0 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2692,7 +2692,7 @@ static inline int restart_syscall(void)
 	return -ERESTARTNOINTR;
 }
 
-static inline int signal_pending(struct task_struct *p)
+static inline int __must_check signal_pending(struct task_struct *p)
 {
 	return unlikely(test_tsk_thread_flag(p,TIF_SIGPENDING));
 }


