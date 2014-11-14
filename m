Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935021AbaKNDlG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 22:41:06 -0500
Received: from smtprelay0054.hostedemail.com ([216.40.44.54]:58719 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934141AbaKNDlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 22:41:05 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:968:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:2901:2918:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6120:6261:7974:10004:10400:10848:11232:11658:11914:12043:12296:12517:12519:12663:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bit80_4335e22c7c63c
X-Filterd-Recvd-Size: 1760
Message-ID: <1415936460.5912.1.camel@perches.com>
Subject: Re: [RFC PATCH] printk: Use ACCESS_ONCE() instead of a volatile type
From: Joe Perches <joe@perches.com>
To: Pranith Kumar <bobby.prani@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Petr Mladek <pmladek@suse.cz>,
        Jan Kara <jack@suse.cz>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        Alex Elder <elder@linaro.org>, Steven Rostedt <rostedt@goodmis.org>,
        open list <linux-kernel@vger.kernel.org>, paulmck@linux.vnet.ibm.com
Date: Thu, 13 Nov 2014 19:41:00 -0800
In-Reply-To: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
References: <1415935283-19198-1-git-send-email-bobby.prani@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-11-13 at 22:21 -0500, Pranith Kumar wrote:
> Remove volatile type qualifier and use ACCESS_ONCE() in its place for each
> access. Using volatile is not recommended as documented in
> Documentation/volatile-considered-harmful.txt.
> 
> Here logbuf_cpu is a local variable and it is not clear how it is being accessed
> concurrently. We should remove volatile accesses entirely here, but for now make
> a safer change of using ACCESS_ONCE().

Not recommended does not mean "don't ever use".

Forcing the volatile at each use site instead
of the declaration isn't necessarily better.

I think the code is more readable as-is but I'm
not going to object if Andrew picks this up...


