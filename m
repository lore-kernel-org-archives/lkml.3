Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759825Ab3JOVAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:00:11 -0400
Received: from smtprelay0117.hostedemail.com ([216.40.44.117]:41946 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757504Ab3JOVAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:00:09 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2393:2559:2562:2691:2828:3138:3139:3140:3141:3142:3350:3622:3865:3867:3871:3872:4321:5007:7652:10004:10400:10848:11026:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: form83_755ecd361a331
X-Filterd-Recvd-Size: 1707
Message-ID: <1381870805.22110.37.camel@joe-AO722>
Subject: Re: [PATCH 2/3] core: Convert printk_once to use DO_ONCE
From: Joe Perches <joe@perches.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Liu Chuansheng <chuansheng.liu@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Date: Tue, 15 Oct 2013 14:00:05 -0700
In-Reply-To: <1381870252-5430-3-git-send-email-fweisbec@gmail.com>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
	 <1381870252-5430-3-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 22:50 +0200, Frederic Weisbecker wrote:
[]
> diff --git a/include/linux/printk.h b/include/linux/printk.h
[]
> @@ -252,14 +253,7 @@ extern asmlinkage void dump_stack(void) __cold;
>  
>  #ifdef CONFIG_PRINTK
>  #define printk_once(fmt, ...)			\
> -({						\
> -	static bool __print_once;		\
> -						\
> -	if (!__print_once) {			\
> -		__print_once = true;		\
> -		printk(fmt, ##__VA_ARGS__);	\
> -	}					\
> -})
> +	DO_ONCE(printk(fmt, ##__VA_ARGS__));

It's hard to believe the overhead is worth it.


