Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab3IPSDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 14:03:35 -0400
Received: from smtprelay0254.hostedemail.com ([216.40.44.254]:46518 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751148Ab3IPSDe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 14:03:34 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2196:2198:2199:2200:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4385:5007:7652:8660:10004:10400:10848:11232:11658:11914:12517:12519:12679:12740:13019:13069:13148:13230:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: rest12_590c46c717563
X-Filterd-Recvd-Size: 1942
Message-ID: <1379354609.1934.26.camel@joe-AO722>
Subject: Re: [PATCH 1/2] remove all uses of printf's %n
From: Joe Perches <joe@perches.com>
To: George Spelvin <linux@horizon.com>
Cc: keescook@chromium.org, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        JBeulich@suse.com, kosaki.motohiro@gmail.com,
        linux-kernel@vger.kernel.org, penguin-kernel@i-love.sakura.ne.jp,
        viro@zeniv.linux.org.uk
Date: Mon, 16 Sep 2013 11:03:29 -0700
In-Reply-To: <20130916172131.8282.qmail@science.horizon.com>
References: <20130916172131.8282.qmail@science.horizon.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-09-16 at 13:21 -0400, George Spelvin wrote:
> > My thought was to add a seq_last_len()
> 
> In addition to adding per-call overhead to support a rarely-used feature
> (while ->pos comes for free), this has the downside that it matters how
> many separate calls are used to generate the string.
> 
> The advantage of the "read ->pos before and after" technique is that
> you can have an arbitrary number of output calls in between.
> Including things like seq_path(), seq_bitmap(), etc.
> 
> If you have the printing done in a subroutine (as in the net/ipv4
> directory), it would be annoyingly subtle if seq_puts("foobar")
> were not equivalent to seq_puts("foo"); seq_puts("bar").

It's already true that those aren't equivalent.
	seq_puts(seq, "short ");
	set_puts(seq, "string");
may fit the first bit into the output buffer but not the last
where
	setq_puts(seq, "short string");
would not fit at all.

btw: who are you?  Is your name really George Spelvin?



