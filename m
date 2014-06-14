Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900AbaFNRCA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 13:02:00 -0400
Received: from smtprelay0179.hostedemail.com ([216.40.44.179]:42851 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754728AbaFNRB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 13:01:58 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:1981:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:3874:4321:4605:5007:7652:7904:10004:10400:10848:11232:11658:11914:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: care00_2df9bd54b9c5c
X-Filterd-Recvd-Size: 1739
Message-ID: <1402765314.2756.20.camel@joe-AO725>
Subject: Re: [PATCH] Coccinelle : Script to detect cast after memory
 allocation
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, linux-kernel@vger.kernel.org
Date: Sat, 14 Jun 2014 10:01:54 -0700
In-Reply-To: <alpine.DEB.2.02.1406141809050.1962@localhost6.localdomain6>
References: <20140614154541.GA4179@himangi-Dell>
	 <1402761961.2756.12.camel@joe-AO725>
	 <alpine.DEB.2.02.1406141809050.1962@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-06-14 at 18:11 +0200, Julia Lawall wrote:
> On Sat, 14 Jun 2014, Joe Perches wrote:
[]
> > Perhaps make this more generic for any void *?
> > 
> > Something like:
> > 
> > @@
> > void *t;
> > type other;
> > @@
> > 
> > -       (other *)t
> > +       t
[]
> Perhaps it would be reasonable to add this among the specific functions.  
> That is, t could be part of the disjunctions.

You do have to make sure that the
"casted to" type is not dereferenced.

ie: don't transform

void func(void *foo)
{
	unsigned long bar = *(unsigned long *)foo;
}

Also there may be some __user cast types and
such that may be necessary to exclude too.



