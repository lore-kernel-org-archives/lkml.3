Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752697AbaF0Fwv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 01:52:51 -0400
Received: from smtprelay0084.hostedemail.com ([216.40.44.84]:49602 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750734AbaF0Fwu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 01:52:50 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:2915:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3873:4321:5007:7652:7904:10004:10400:10848:11232:11658:11914:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: money59_3595b5106181e
X-Filterd-Recvd-Size: 1589
Message-ID: <1403848366.7977.92.camel@joe-AO725>
Subject: Re: [PATCH] HID: roccat: Drop cast
From: Joe Perches <joe@perches.com>
To: Julia Lawall <julia.lawall@lip6.fr>
Cc: Himangi Saraogi <himangi774@gmail.com>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Thu, 26 Jun 2014 22:52:46 -0700
In-Reply-To: <alpine.DEB.2.02.1406270729110.2016@localhost6.localdomain6>
References: <20140626172852.GA2878@himangi-Dell>
	 <1403804286.7977.58.camel@joe-AO725>
	 <alpine.DEB.2.02.1406270729110.2016@localhost6.localdomain6>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-06-27 at 07:29 +0200, Julia Lawall wrote:
> On Thu, 26 Jun 2014, Joe Perches wrote:
> > The cast of a const void * to a void * was odd.
> > 
> > Maybe a mechanism to verify appropriateness of
> > loss of constness for any pointer might be useful.
> 
> I tried the following, but didn't find anything interesting:
> 
> @disable drop_cast@
> type T;
> const T e;
> @@
> 
> * (T)e

What code does this match?
Do you have an example match?

This doesn't find a cast of a void type like:

void func(const void * const p)
{
	char *p2 = p;

	p2[0] = 1;
}


