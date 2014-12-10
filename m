Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932860AbaLJTiK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 14:38:10 -0500
Received: from smtprelay0056.hostedemail.com ([216.40.44.56]:37388 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932721AbaLJTiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 14:38:08 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1539:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3867:3868:3871:3872:3873:3874:4321:5007:6261:7904:10004:10400:10848:11026:11232:11658:11914:12043:12295:12517:12519:12740:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: flesh31_299fadd2be51c
X-Filterd-Recvd-Size: 1666
Message-ID: <1418240283.18092.15.camel@perches.com>
Subject: Re: [PATCH] irda: Convert function pointer arrays and uses to const
From: Joe Perches <joe@perches.com>
To: "Rustad, Mark D" <mark.d.rustad@intel.com>
Cc: Samuel Ortiz <samuel@sortiz.org>, "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Dec 2014 11:38:03 -0800
In-Reply-To: <3333024A-D21C-41E2-80ED-7590CE6E9BD1@intel.com>
References: <1418236138.18092.13.camel@perches.com>
	 <3333024A-D21C-41E2-80ED-7590CE6E9BD1@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-12-10 at 19:32 +0000, Rustad, Mark D wrote:
> On Dec 10, 2014, at 10:28 AM, Joe Perches <joe@perches.com> wrote:
[]
> > diff --git a/include/net/irda/parameters.h b/include/net/irda/parameters.h
[]
> > typedef struct {
> > -	pi_minor_info_t *pi_minor_call_table;
> > +	const pi_minor_info_t *pi_minor_call_table;
> 
> Might you want to go a little further and make it:
> 	const pi_minor_into_t * const pi_minor_call_table;
> so that the pointer itself is also constant? That could apply to some others below as well.
> 
> > 	int len;
> > } pi_major_info_t;

I don't think that's necessary as all the pi_major_info_t uses
become const and this is a typedef, but if you want to, go ahead.


