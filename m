Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161735AbaKNTOv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 14:14:51 -0500
Received: from smtprelay0055.hostedemail.com ([216.40.44.55]:36048 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1161200AbaKNTOu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 14:14:50 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1461:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3870:3871:3872:4321:5007:6261:7901:7903:8531:8778:10004:10400:10848:11232:11658:11914:12050:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beef94_46fc6604c7836
X-Filterd-Recvd-Size: 1725
Message-ID: <1415992486.5912.23.camel@perches.com>
Subject: Re: [PATCH 1/1 net-next] net: dsa: replace count*size kmalloc by
 kmalloc_array
From: Joe Perches <joe@perches.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 14 Nov 2014 11:14:46 -0800
In-Reply-To: <2104595537.56209.1415991758726.open-xchange@webmail.nmp.skynet.be>
References: <1415990202-28673-1-git-send-email-fabf@skynet.be>
	 <1415990835.5912.20.camel@perches.com>
	 <2104595537.56209.1415991758726.open-xchange@webmail.nmp.skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-14 at 20:02 +0100, Fabian Frederick wrote:
> On 14 November 2014 at 19:47 Joe Perches <joe@perches.com> wrote:
> > On Fri, 2014-11-14 at 19:36 +0100, Fabian Frederick wrote:
> > > kmalloc_array manages count*sizeof overflow.
> >
> > Fundamentally correct, but is this necessary or useful?
> > sizeof(s8) isn't often going to be anything other than 1.
> Absolutely, I thought it was a struct :)
> 
> There must be a reason for so many cases though ...

Some might be style symmetry for other sizeof(othertype)
uses in the same paths, but most of them are just overkill
or maybe lack of understanding.

s8 is char so by definition it has to be 1.

I doubt any of the code dates from PDP-8/TOPS-10 days.


