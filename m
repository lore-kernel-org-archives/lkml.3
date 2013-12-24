Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab3LXPFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Dec 2013 10:05:23 -0500
Received: from smtprelay0149.hostedemail.com ([216.40.44.149]:59506 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752301Ab3LXPFV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Dec 2013 10:05:21 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:152:355:379:541:599:973:982:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2687:2911:3138:3139:3140:3141:3142:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4321:4425:5007:7652:7903:10004:10400:10481:10848:11026:11232:11658:11783:11914:12295:12438:12517:12519:12740:13069:13311:13357:13894:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cake59_4b70999a21556
X-Filterd-Recvd-Size: 2717
Message-ID: <1387897517.2259.41.camel@joe-AO722>
Subject: Re: [PATCH v2 01/20] net: slight optimization of addr compare for
 some modules
From: Joe Perches <joe@perches.com>
To: Ding Tianhong <dthxman@gmail.com>
Cc: Ding Tianhong <dingtianhong@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        e1000-devel@lists.sourceforge.net
Date: Tue, 24 Dec 2013 07:05:17 -0800
In-Reply-To: <52B99BB9.9030201@gmail.com>
References: <52B96F9B.4020806@huawei.com>
	 <1387894944.2259.31.camel@joe-AO722> <52B99BB9.9030201@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-12-24 at 22:35 +0800, Ding Tianhong wrote:
> 于 2013/12/24 22:22, Joe Perches 写道:
> > On Tue, 2013-12-24 at 19:27 +0800, Ding Tianhong wrote:
> >> Use possibly more efficient ether_addr_equal_unaligned
> >> and ether_addr_equal to instead of memcmp.
> > 
> > A negative of adding so many different drivers in a single
> > patch is that you miss sending patches to the named maintainers.
> > 
> > Most of these below have separate individual maintainers.
>
> you mean that I should send below by separate patch?

I think yes,

You can send them to netdev, but cc'ing the named
maintainers is a polite thing to do.

Sending individual patches can make it easier for
maintainers to review the bits that are specific
to their projects without having to wade through
other changes that aren't relevant to them.

> It seemed that I 
> misunderstood, I use the ./script/getmainter and found the only maintainer
> is David, and others are support, so maybe I was wrong, but it really a big
> patchset, could I send them by seperate patchset? I think it could be more
> clearly.

>From the MAINTAINERS file:
	S: Status, one of the following:
	   Supported:	Someone is actually paid to look after this.
	   Maintained:	Someone actually looks after it.
	   Odd Fixes:	It has a maintainer but they don't have time to do
			much other than throw the odd patch in. See below..
	   Orphan:	No current maintainer [but maybe you could take the
			role as you write your new code].
	   Obsolete:	Old code. Something tagged obsolete generally means
			it has been replaced by a better system and you
			should be using that.

So "supported" is "higher/better" than "maintained".


