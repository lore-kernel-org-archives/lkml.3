Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052AbaELTSD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:18:03 -0400
Received: from smtprelay0072.hostedemail.com ([216.40.44.72]:44261 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752124AbaELTSB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:18:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:981:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1542:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3354:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:7652:7901:8603:8660:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12555:12663:12740:13132:13148:13149:13161:13229:13230:13231:14040,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: glass77_28a3ac433c93c
X-Filterd-Recvd-Size: 3265
Message-ID: <1399922277.9240.50.camel@joe-AO725>
Subject: Re: [PATCH 1/1] net/wireless/ibss.c: replace memcpy by
 ether_addr_copy
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Fabian Frederick <fabf@skynet.be>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Date: Mon, 12 May 2014 12:17:57 -0700
In-Reply-To: <1399920710.4337.26.camel@jlt4.sipsolutions.net>
References: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
	 <1399917025.9240.16.camel@joe-AO725>
	 <20140512200033.87712053add71ca2cf35fe79@skynet.be>
	 <1399918029.9240.19.camel@joe-AO725>
	 <1399920710.4337.26.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 20:51 +0200, Johannes Berg wrote:
> On Mon, 2014-05-12 at 11:07 -0700, Joe Perches wrote:
> > On Mon, 2014-05-12 at 20:00 +0200, Fabian Frederick wrote:
> > > On Mon, 12 May 2014 10:50:25 -0700
> > > Joe Perches <joe@perches.com> wrote:
> > > > On Mon, 2014-05-12 at 19:30 +0200, Fabian Frederick wrote:
> > > > > This patch also fixes some comment checkpatch warnings
> > > > For all the patches that replace memcpy(foo, bar, ETH_ALEN)
> > > > with ether_addr_copy, did you use a tool to verify both
> > > > arguments are __aligned(2) or did you do the verification
> > > > visually?
> > > I only replaced ETH_ALEN/memcpy .
> > > AFAICS ETH_ALEN is defined 6 ...
> > 
> > The difference here is that both arguments to
> > ether_addr_copy, like all the is_<foo>_ether_addr
> > helpers, must be __aligned(2).  memcpy has
> > no alignment requirement.
> > 
> > Please verify that all these changes are to
> > __aligned(2) arguments.
> 
> Seriously though, who cares. Only two of these patches really touch
> paths where performance matters - and one of those is the lib80211 one
> which is practically only used for certain ancient Intel devices, which
> probably don't run on anything but IA where I'd guess the whole thing
> doesn't really matter anyway.
> 
> I certainly don't see the benefit in changing all those other files,
> particularly since it's not just that we have to verify alignment *now*,
> we also have to add alignment attributes so that we don't break
> alignment in the future.

The same alignment requirements exist in quite a
lot of the code so I don't see that as much of a
continuing problem.

It's more of an initial conversion problem.

> Additionally doesn't even really save much typing:
> 
> memcpy(x, y, ETH_ALEN);
> ether_addr_copy(x, y);

To me the general benefit isn't in the reduced
source code size, but small improvements for
ARM both in code size and execution speed.

I'm not sure it's worth even the initial conversion
verification costs though.  It's quite tedious to
go through the call trees and I don't know of an
automated way to do that.

