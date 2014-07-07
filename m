Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753184AbaGGN0Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 09:26:24 -0400
Received: from smtprelay0214.hostedemail.com ([216.40.44.214]:35443 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752703AbaGGN0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 09:26:23 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:960:968:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2198:2199:2393:2559:2562:2731:2828:3138:3139:3140:3141:3142:3315:3353:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:5007:6119:7576:7652:7903:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13161:13229:13311:13357:14040:14096:14097:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: jeans14_54313a52b8625
X-Filterd-Recvd-Size: 3057
Message-ID: <1404739577.27043.65.camel@joe-AO725>
Subject: Re: [PATCH] vsprintf: Remove SPECIAL from pointer types
From: Joe Perches <joe@perches.com>
To: David Laight <David.Laight@ACULAB.COM>
Cc: "Maciej W. Rozycki" <macro@linux-mips.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 07 Jul 2014 06:26:17 -0700
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D1726D4E1@AcuExch.aculab.com>
References: <alpine.LFD.2.11.1406290246120.15455@eddie.linux-mips.org>
	 <20140702.182807.1245632778216212860.davem@davemloft.net>
	 <alpine.LFD.2.11.1407030244230.15455@eddie.linux-mips.org>
	 <alpine.LFD.2.11.1407030331550.15455@eddie.linux-mips.org>
	 <1404356734.14741.18.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030423300.15455@eddie.linux-mips.org>
	 <1404364565.14741.26.camel@joe-AO725>
	 <alpine.LFD.2.11.1407030637030.15455@eddie.linux-mips.org>
	 <1404368746.14741.36.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051529040.15455@eddie.linux-mips.org>
	 <1404576420.6384.41.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051833400.15455@eddie.linux-mips.org>
	 <1404583739.6384.51.camel@joe-AO725>
	 <alpine.LFD.2.11.1407051917480.15455@eddie.linux-mips.org>
	 <1404585099.6384.53.camel@joe-AO725>
	 <alpine.LFD.2.11.1407052103130.15455@eddie.linux-mips.org>
	 <1404593114.6384.72.camel@joe-AO725>
	 <063D6719AE5E284EB5DD2968C1650D6D1726D4E1@AcuExch.aculab.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-07-07 at 08:26 +0000, David Laight wrote:
> From: Joe Perches
> > Because gcc issues a complaint about any pointer format with %#p,
> > remove the use of SPECIAL to prefix 0x to various pointer types.
> > 
> > There are no uses in the kernel tree of %#p.
> 
> I know you guys don't really care about them, but there might
> be uses in out of tree drivers.
> 
> With the change what is output for %#p ?

Linux's output of %#p for normal, non %p<foo> extension use,
continues to be prefixed with 0x and zero filled.

Prior to this proposed change:
%#p uses a fixed width of sizeof(void *) * 2 + 2.
%p uses a fixed with of sizeof(void *) * 2

Post:
%#p uses a variable width of the minimum of sizeof(void *) * 2
to sizeof(void *) * 2 + 2 depending on the high order 2 bytes
of the pointer value.

There is no in-kernel tree code that uses %#p so it
has no net effect.

Personally, I prefer %#p uses the "+ 2" fixed width.

The real benefit is removing the auto-prefixing of 0x
when using the %pa extension to be consistent with
other naked pointer output types.


