Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752351Ab3INF0H (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 01:26:07 -0400
Received: from smtprelay0238.hostedemail.com ([216.40.44.238]:36676 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751884Ab3INF0F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 01:26:05 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3866:3867:3868:3871:3872:3873:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not 
X-HE-Tag: patch68_34b49e90ad40f
X-Filterd-Recvd-Size: 1863
Message-ID: <1379136360.1973.10.camel@joe-AO722>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
From: Joe Perches <joe@perches.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>, keescook@chromium.org,
        linux@horizon.com, akpm@linux-foundation.org, dan.carpenter@oracle.com,
        davem@davemloft.net, eldad@fogrefinery.com, jbeulich@suse.com,
        jkosina@suse.cz, linux-kernel@vger.kernel.org, rdunlap@infradead.org
Date: Fri, 13 Sep 2013 22:26:00 -0700
In-Reply-To: <20130914045313.GB13318@ZenIV.linux.org.uk>
References: <20130913195335.18955.qmail@science.horizon.com>
	 <1379111268.2066.22.camel@joe-AO722>
	 <CAGXu5jJxJVK7cu2Sc4Sdng_rLDL8ziC6aecAi7G0zL4fYnY-9Q@mail.gmail.com>
	 <201309141149.HGF39054.QLJVHFtMFOSOOF@I-love.SAKURA.ne.jp>
	 <20130914030521.GZ13318@ZenIV.linux.org.uk>
	 <20130914034801.GA13318@ZenIV.linux.org.uk>
	 <20130914045313.GB13318@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-09-14 at 05:53 +0100, Al Viro wrote:
> The bottom line: most of these guys could as well return void; we have
> few overflow checks and those could be made explicit.  As it is,
> "return -1 on overflow" had been a mistake.

What do you think of adding last_ret and last_len to
struct seq_file?  Is there any case where it's racy?

I haven't noticed one, but dunno.

Another option might be to use something like:

struct seq_rtn {
	int rtn;
	size_t len;
}

as the return for all the seq_<foo> funcs.


