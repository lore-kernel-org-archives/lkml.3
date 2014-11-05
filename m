Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaKETbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 14:31:07 -0500
Received: from smtprelay0195.hostedemail.com ([216.40.44.195]:36133 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751081AbaKETbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 14:31:03 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:2895:3138:3139:3140:3141:3142:3352:3622:3653:3865:3866:3867:3868:3870:3872:3874:4321:5007:6119:6261:7903:8660:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13148:13230:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: lamp69_7c5cfd7f79637
X-Filterd-Recvd-Size: 1844
Message-ID: <1415215852.6634.21.camel@perches.com>
Subject: Re: [PATCH] checkpatch: Add --strict test for function pointer
 calling style
From: Joe Perches <joe@perches.com>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Date: Wed, 05 Nov 2014 11:30:52 -0800
In-Reply-To: <545A76B7.1060801@hurleysoftware.com>
References: <1415208392-16189-1-git-send-email-peter@hurleysoftware.com>
	 <1415208392-16189-3-git-send-email-peter@hurleysoftware.com>
	 <1415212917.6634.17.camel@perches.com>
	 <545A76B7.1060801@hurleysoftware.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 14:12 -0500, Peter Hurley wrote:
> On 11/05/2014 01:41 PM, Joe Perches wrote:
> > Peter Hurley wrote:
> > 
> > The use of older function ptr calling style, (*fn)(), makes static
> > analysis more error-prone; replace with modern fn() style.
> > 
> > So make checkpatch emit a --strict test for that condition.
> > 
> > Update the unnecessary parentheses test for dereferencing
> > objects at the same time and create a $fix mechanism too.
> 
> Cool.
> 
> perl's not my thing; how does it know not to trip up on
> 
> 	initcall_t *call;
> 
> 	(*call)();
> 
> [which I verified it properly does not flag in drivers/tty/tty_io.c]

because the regex only matches "(foo->bar)("

It doesn't match (*foo->bar)("

and foo->bar could be any number of -> or . uses like

"(foo->bar.baz)("

or

"( foo -> bar . baz ) ("

