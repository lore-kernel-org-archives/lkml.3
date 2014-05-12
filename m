Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119AbaELSHQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 14:07:16 -0400
Received: from smtprelay0251.hostedemail.com ([216.40.44.251]:41274 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752043AbaELSHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 14:07:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3352:3622:3865:3867:3871:3873:3874:4321:5007:7652:7901:8828:10004:10400:10848:10967:11026:11232:11658:11914:12296:12517:12519:12740:13069:13132:13161:13229:13231:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: cable84_4a72dbac7b4d
X-Filterd-Recvd-Size: 1861
Message-ID: <1399918029.9240.19.camel@joe-AO725>
Subject: Re: [PATCH 1/1] net/wireless/ibss.c: replace memcpy by
 ether_addr_copy
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        akpm <akpm@linux-foundation.org>
Date: Mon, 12 May 2014 11:07:09 -0700
In-Reply-To: <20140512200033.87712053add71ca2cf35fe79@skynet.be>
References: <20140512193050.1ba6a301b20af3f4e7e43870@skynet.be>
	 <1399917025.9240.16.camel@joe-AO725>
	 <20140512200033.87712053add71ca2cf35fe79@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-12 at 20:00 +0200, Fabian Frederick wrote:
> On Mon, 12 May 2014 10:50:25 -0700
> Joe Perches <joe@perches.com> wrote:
> 
> > On Mon, 2014-05-12 at 19:30 +0200, Fabian Frederick wrote:
> > > This patch also fixes some comment checkpatch warnings
> > 
> > Hello Fabian.
> > 
> > For all the patches that replace memcpy(foo, bar, ETH_ALEN)
> > with ether_addr_copy, did you use a tool to verify both
> > arguments are __aligned(2) or did you do the verification
> > visually?
> 
> Hello Joe,
> 
> I only replaced ETH_ALEN/memcpy .
> AFAICS ETH_ALEN is defined 6 ...

The difference here is that both arguments to
ether_addr_copy, like all the is_<foo>_ether_addr
helpers, must be __aligned(2).  memcpy has
no alignment requirement.

Please verify that all these changes are to
__aligned(2) arguments.


