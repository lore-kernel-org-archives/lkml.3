Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933892Ab3JOVYp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 17:24:45 -0400
Received: from smtprelay0058.hostedemail.com ([216.40.44.58]:44032 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932555Ab3JOVYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 17:24:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 50,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::,RULES_HIT:41:355:379:541:599:967:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2525:2553:2561:2564:2682:2685:2691:2828:2859:2933:2937:2939:2942:2945:2947:2951:2954:3022:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3872:3873:3874:3934:3936:3938:3941:3944:3947:3950:3953:3956:3959:4321:5007:6117:7652:9025:10004:10400:10848:11026:11232:11658:11914:12043:12296:12517:12519:12679:12740:13069:13161:13229:13311:13357:13845,0,RBL:none,CacheIP:none,Bayesian:0.5,0.
X-HE-Tag: pets00_28ef78a304634
X-Filterd-Recvd-Size: 2312
Message-ID: <1381872280.22110.41.camel@joe-AO722>
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
Date: Tue, 15 Oct 2013 14:24:40 -0700
In-Reply-To: <20131015211251.GE3269@localhost.localdomain>
References: <1381870252-5430-1-git-send-email-fweisbec@gmail.com>
	 <1381870252-5430-3-git-send-email-fweisbec@gmail.com>
	 <1381870805.22110.37.camel@joe-AO722>
	 <20131015211251.GE3269@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-15 at 23:12 +0200, Frederic Weisbecker wrote:
> On Tue, Oct 15, 2013 at 02:00:05PM -0700, Joe Perches wrote:
> > On Tue, 2013-10-15 at 22:50 +0200, Frederic Weisbecker wrote:
> > []
> > > diff --git a/include/linux/printk.h b/include/linux/printk.h
> > []
> > > @@ -252,14 +253,7 @@ extern asmlinkage void dump_stack(void) __cold;
> > >  
> > >  #ifdef CONFIG_PRINTK
> > >  #define printk_once(fmt, ...)			\
> > > -({						\
> > > -	static bool __print_once;		\
> > > -						\
> > > -	if (!__print_once) {			\
> > > -		__print_once = true;		\
> > > -		printk(fmt, ##__VA_ARGS__);	\
> > > -	}					\
> > > -})
> > > +	DO_ONCE(printk(fmt, ##__VA_ARGS__));
> > 
> > It's hard to believe the overhead is worth it.
> 
> Which overhead?

The one you were proposing with xchg

Apparently the 1/3 series you submitted
didn't use it.

Given that it didn't, does the indirection
to DO_ONCE really help?

btw:

https://lkml.org/lkml/2009/5/21/300

Perhaps Alan's comment still applies:

https://lkml.org/lkml/2009/5/21/305


