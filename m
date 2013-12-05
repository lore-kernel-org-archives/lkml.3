Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab3LEXhE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 18:37:04 -0500
Received: from smtprelay0001.hostedemail.com ([216.40.44.1]:42999 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752560Ab3LEXg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 18:36:59 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:966:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2196:2199:2393:2553:2559:2562:2740:2828:2914:3138:3139:3140:3141:3142:3352:3622:3865:3868:3872:3873:4321:4385:4605:5007:6119:7652:8531:10004:10400:10481:10848:10967:11026:11232:11473:11658:11914:12043:12438:12517:12519:12740:13069:13255:13311:13357:19900,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: stove02_59c686d945b28
X-Filterd-Recvd-Size: 1767
Message-ID: <1386286615.10003.30.camel@joe-AO722>
Subject: Re: [PATCH net-next] ether_addr_equal: Optimize implementation,
 remove unused compare_ether_addr
From: Joe Perches <joe@perches.com>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org, Rob Landley <rob@landley.net>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Dec 2013 15:36:55 -0800
In-Reply-To: <20131205153229.187f7604@nehalam.linuxnetplumber.net>
References: <34a0bad292ab2535a3a2e757a83eca13408e55b7.1386283991.git.joe@perches.com>
	 <20131205153229.187f7604@nehalam.linuxnetplumber.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-12-05 at 15:32 -0800, Stephen Hemminger wrote:
> On Thu,  5 Dec 2013 14:54:38 -0800
> Joe Perches <joe@perches.com> wrote:
> 
> > +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
> > +	u32 fold = ((*(const u32 *)addr1) ^ (*(const u32 *)addr2)) |
> > +		   ((*(const u16 *)(addr1 + 4)) ^ (*(const u16 *)(addr2 + 4)));
> > +
> > +	return fold == 0;
> 
> Why the temporary variable.

It's cost free and I think a bit more readable.

>  You can just do:
> 	return ((*(const u32 *)addr1) ^ (*(const u32 *)addr2)) |
> 	       ((*(const u16 *)(addr1 + 4)) ^ (*(const u16 *)(addr2 + 4))) != 0;

== 0

> Or
> 	return !!((*(const u32 *)addr1) ^ (*(const u32 *)addr2)) |
> 	         ((*(const u16 *)(addr1 + 4)) ^ (*(const u16 *)(addr2 + 4))));

!!!? :)


