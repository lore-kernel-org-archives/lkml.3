Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751692AbaAKBhE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 20:37:04 -0500
Received: from smtprelay0108.hostedemail.com ([216.40.44.108]:41273 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750931AbaAKBg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 20:36:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3867:3868:3871:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12533:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: plate66_1f245b479ea3e
X-Filterd-Recvd-Size: 1720
Message-ID: <1389404212.2537.47.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT format specifier
From: Joe Perches <joe@perches.com>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: akpm@linux-foundation.org, pavel@ucw.cz, keescook@chromium.org,
        geert@linux-m68k.org, jkosina@suse.cz, viro@zeniv.linux.org.uk,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Fri, 10 Jan 2014 17:36:52 -0800
In-Reply-To: <201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
References: <201401092151.FIB00084.SJFOLVOMQHtFOF@I-love.SAKURA.ne.jp>
	 <20140110160430.526efb3ea91783fe8a32fec5@linux-foundation.org>
	 <201401111028.DEG34385.FVHtLOFMQJFSOO@I-love.SAKURA.ne.jp>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-01-11 at 10:28 +0900, Tetsuo Handa wrote:
>   Step 1: (targeted to 3.14-rc1)
>     Add "%pT" format specifier and commcpy() wrapper function.
> 
>   Step 2: (started after step 1 is reflected to other git trees)
>     Replace printk("%s", p->comm) with printk("%pT", p).

Replace printk("%s", current->comm) with printk("%pT", NULL);

?

>     Replace strcpy(buf, p->comm) with commcpy(buf, p).

>   Step 3: (started after step 2 is reflected to other git trees)
>     Add rcu_read_lock()/rcu_read_unlock() into commcpy().
>     Modify set_task_comm() etc. to replace ->comm using RCU.

Aren't steps 2 and 3 independent?

