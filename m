Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618AbaCFXmf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 18:42:35 -0500
Received: from smtprelay0093.hostedemail.com ([216.40.44.93]:33671 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751003AbaCFXme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 18:42:34 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:800:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2110:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3872:3874:4321:5007:6119:7652:8957:10004:10400:10848:10967:11026:11232:11473:11658:11914:12043:12517:12519:12663:12740:13069:13255:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: able74_333eef837c92e
X-Filterd-Recvd-Size: 2310
Message-ID: <1394149350.16156.13.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch: net and drivers/net: Warn on missing blank
 line after variable declaration
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, kys@microsoft.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, apw@canonical.com
Date: Thu, 06 Mar 2014 15:42:30 -0800
In-Reply-To: <20140306153530.bd61c160ba6f7872d6967b2e@linux-foundation.org>
References: <1394104358-23438-1-git-send-email-kys@microsoft.com>
	 <1394104390-23477-1-git-send-email-kys@microsoft.com>
	 <20140306.142919.763823800315842610.davem@davemloft.net>
	 <1394148520.16156.8.camel@joe-AO722>
	 <20140306153530.bd61c160ba6f7872d6967b2e@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-03-06 at 15:35 -0800, Andrew Morton wrote:
> On Thu, 06 Mar 2014 15:28:40 -0800 Joe Perches <joe@perches.com> wrote:
> > Networking prefers this style, so warn when it's not used.
> > void foo(int bar)
> > {
> > 	int baz;
> > 
> > 	code...
> > }
> > 
> > not
> > 
> > void foo(int bar)
> > {
> > 	int baz;
> > 	code...
> > }
> > 
> > There are a limited number of false positives when using
> > macros to declare variables like:
> > 
> > WARNING: networking uses a blank line after declarations
> > #330: FILE: net/ipv4/inet_hashtables.c:330:
> > +	int dif = sk->sk_bound_dev_if;
> > +	INET_ADDR_COOKIE(acookie, saddr, daddr)
> 
> um wait wut wot.
> 
> *All* kernel code uses blank line between end-of-locals and
> start-of-code.  Or if it doesn't it should, thwap.
> Why are we special-casing net/?

It's easy enough to remove the path test, but it's
not in CodingStyle and David seems to be the one
that makes the effort to correct people about it.

I don't care one way or another.

I'm just trying to get fewer rejections for people
that use checkpatch.

cheers, Joe

