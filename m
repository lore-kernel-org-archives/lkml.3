Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752561AbaKGRQ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 12:16:57 -0500
Received: from smtprelay0006.hostedemail.com ([216.40.44.6]:51992 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751655AbaKGRQz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 12:16:55 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3874:4321:4470:5007:6119:6261:7903:10004:10400:10848:11026:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:14096:14097:21063:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flock20_59050b7004938
X-Filterd-Recvd-Size: 2108
Message-ID: <1415380610.23530.12.camel@perches.com>
Subject: Re: [PATCH v2 3.18-rc3] kdb: Avoid printing KERN_ levels to consoles
From: Joe Perches <joe@perches.com>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Jason Wessel <jason.wessel@windriver.com>, linux-kernel@vger.kernel.org,
        kgdb-bugreport@lists.sourceforge.net,
        Andrew Morton <akpm@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>, stable@vger.kernel.org
Date: Fri, 07 Nov 2014 09:16:50 -0800
In-Reply-To: <545CF847.3020409@linaro.org>
References: <1415287626-25802-1-git-send-email-daniel.thompson@linaro.org>
	 <1415361686-3797-1-git-send-email-daniel.thompson@linaro.org>
	 <1415376272.23530.10.camel@perches.com> <545CF847.3020409@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 16:50 +0000, Daniel Thompson wrote:
> On 07/11/14 16:04, Joe Perches wrote:
> > why insert KERN_INFO?
> 
> vkdb_printf() and  printk() can appear either way round in a stack
> trace. Each is capable of calling the other and a flag (kdb_trap_printk)
> is used to prevent mutual recursion.

I see.

> A complete solution would require a means to know whether vkdb_printf()
> were entered directly or from printk(). A flag passed to vkdb_printf()
> would achieve this. I'll take a look.

That bit seems pretty simple and sensible.

I don't know this code at all but would it be better if
the kdb_trap_printk accesses were converted to atomic_<foo>?

Might this bit in vkdb_printf:

	saved_trap_printk = kdb_trap_printk;
	kdb_trap_printk = 0;

be better atomic_xchg?

and the kdb_trap_printk++ bits as atomic_inc, etc...

