Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbaETBZq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 21:25:46 -0400
Received: from smtprelay0121.hostedemail.com ([216.40.44.121]:54736 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750894AbaETBZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 21:25:44 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1537:1568:1593:1594:1711:1714:1730:1747:1777:1792:2198:2199:2393:2553:2559:2562:2828:2903:3138:3139:3140:3141:3142:3622:3865:3868:3872:3874:4321:5007:7652:10004:10400:10848:11232:11658:11914:12296:12517:12519:12740:13019:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: debt54_149b59f5f153b
X-Filterd-Recvd-Size: 1452
Message-ID: <1400549140.19786.6.camel@joe-AO725>
Subject: Re: [PATCH driver-core-linus] sysfs: make sure read buffer is zeroed
From: Joe Perches <joe@perches.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Ron <ron@debian.org>, Ben Hutchings <ben@decadent.org.uk>
Date: Mon, 19 May 2014 18:25:40 -0700
In-Reply-To: <20140520004955.GA30633@mtj.dyndns.org>
References: <20140519172334.GK20439@audi.shelbyville.oz>
	 <20140519195210.GA27506@mtj.dyndns.org> <20140519222500.GA14616@kroah.com>
	 <1400538742.14238.51.camel@joe-AO725>
	 <20140520004955.GA30633@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-05-19 at 20:49 -0400, Tejun Heo wrote:
> On Mon, May 19, 2014 at 03:32:22PM -0700, Joe Perches wrote:
> > > > +	memset(buf, 0, PAGE_SIZE);
> > 
> > 	memset(buf, 0, count)?
> 
> It's always PAGE_SIZE.  Outputs longer than that are truncated.

Yeah, I know, but the code and comment above it don't match.

/* acquire buffer and ensure that it's >= PAGE_SIZE and clear */



