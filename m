Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaENUoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 16:44:16 -0400
Received: from smtprelay0199.hostedemail.com ([216.40.44.199]:57893 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751143AbaENUoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 16:44:15 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3874:4321:5007:6119:7576:7652:7903:10004:10400:10848:10967:11026:11232:11473:11658:11914:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: scale45_24d3b7d847f48
X-Filterd-Recvd-Size: 1793
Message-ID: <1400100249.30384.32.camel@joe-AO725>
Subject: Re: [PATCH] net: Use a more standard macro for INET_ADDR_COOKIE
From: Joe Perches <joe@perches.com>
To: David Miller <davem@redhat.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 14 May 2014 13:44:09 -0700
In-Reply-To: <20140514.160845.214090653562722244.davem@redhat.com>
References: <1400038207.24350.83.camel@joe-AO725>
	 <20140514.160845.214090653562722244.davem@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-14 at 16:08 -0400, David Miller wrote:
> From: Joe Perches <joe@perches.com>
> Date: Tue, 13 May 2014 20:30:07 -0700
> 
> > Missing a colon on definition use is a bit odd so
> > change the macro for the 32 bit case to declare an
> > __attribute__((unused)) and __deprecated variable.
> > 
> > The __deprecated attribute will cause gcc to emit
> > an error if the variable is actually used.
> > 
> > Signed-off-by: Joe Perches <joe@perches.com>
> 
> This is fine, applied, thanks Joe.
> 
> Perhaps it would have been nicer to make the macros be initializers,
> so that it still would look like a proper variable declaration at
> the use sites:
> 
> 	const __addrpair var = INET_ADDR_COOKIE(x, y, z);
> 
> or something like that.

Maybe so, but there's no way to add an __attribute__
before the = sign for the 32 bit case like that without
another #define and it would then always require
initialization too.


