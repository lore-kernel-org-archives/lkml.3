Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751014Ab3L1UY7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 15:24:59 -0500
Received: from smtprelay0181.hostedemail.com ([216.40.44.181]:57458 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750739Ab3L1UY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 15:24:58 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:2901:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3872:3874:4250:4321:4605:5007:7652:7904:8603:10004:10400:10848:10967:11026:11232:11473:11658:11914:12296:12517:12519:12740:13019:13069:13161:13229:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: ring41_2b054337b1d55
X-Filterd-Recvd-Size: 2544
Message-ID: <1388262293.24123.22.camel@joe-AO722>
Subject: Re: [PATCH] lib/vsprintf: add %pT[C012] format specifier
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Jiri Kosina <jkosina@suse.cz>, Al Viro <viro@zeniv.linux.org.uk>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Sat, 28 Dec 2013 12:24:53 -0800
In-Reply-To: <20131228120815.31f7d378.akpm@linux-foundation.org>
References: <201312252137.IDC43215.OLtJQFHOFMVFSO@I-love.SAKURA.ne.jp>
	 <20131227150211.61328c02d61722cb212649e9@linux-foundation.org>
	 <201312281243.CCB82366.tMHFVQFSOOFJOL@I-love.SAKURA.ne.jp>
	 <CAMuHMdXVrL-9Fq3ixCZvh1TubGg7HFc0HKPbq-YYu+Q1zxWcEA@mail.gmail.com>
	 <20131228112509.8a62548c.akpm@linux-foundation.org>
	 <CAMuHMdWfi4mSQLA01_fYrs1ybQ5YysO2EF4q1EBNy+7nbKXN6g@mail.gmail.com>
	 <1388260405.24123.18.camel@joe-AO722>
	 <20131228120815.31f7d378.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-12-28 at 12:08 -0800, Andrew Morton wrote:
> On Sat, 28 Dec 2013 11:53:25 -0800 Joe Perches <joe@perches.com> wrote:
> 
> > > > #define PRINTK_PID      "\002"
> > > > #define PRINTK_TASK_ID  "\003"  /* "comm:pid" */

> > > >
> > > >         printk(PRINTK_TASK_ID ": hair on fire\n");
> > > >
> > > > It's certainly compact.  I doubt if there's any existing code which
> > > > deliberately prints control chars?
> > > 
> > > But the rest looks OK to me.
> > 
> > Tell me again, what's wrong with using p or current?
> > 
> > printk("%pt", current);
> 
> Nothing much.  It's just that all these callsites are generating the
> code to pass an argument which the callee already has access to. 
> Optimizing that will reduce text size a bit.

There have been smaller reductions in code size
than that...

> There's also the matter of providing a standard and abstracted way of
> representing a task, instead of directly accessing its ->comm.  But
> that's a separate thing from new printk tokens.

OK then perhaps use KERN_<ATTR> or CURRENT_<ATTR>
rather than PRINTK_<ATTR>



