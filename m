Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752921AbaEUUHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:07:51 -0400
Received: from smtprelay0183.hostedemail.com ([216.40.44.183]:56595 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751137AbaEUUHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:07:49 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3872:4321:5007:7652:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12740:13069:13149:13230:13311:13357:13894,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: verse60_7e350a65d3759
X-Filterd-Recvd-Size: 1798
Message-ID: <1400702866.11896.4.camel@joe-AO725>
Subject: Re: [PATCH 1/2] mISDN: Use time_before()
From: Joe Perches <joe@perches.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Cc: Manuel =?ISO-8859-1?Q?Sch=F6lling?= <manuel.schoelling@gmx.de>,
        isdn@linux-pingi.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 May 2014 13:07:46 -0700
In-Reply-To: <537CFE29.7050100@cogentembedded.com>
References: <1400699406-31294-1-git-send-email-manuel.schoelling@gmx.de>
	 <537CFE29.7050100@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-05-21 at 23:27 +0400, Sergei Shtylyov wrote:
> On 05/21/2014 11:10 PM, Manuel Schölling wrote:
> > To be future-proof and for better readability the time comparisons are modified
> > to use time_before() instead of plain, error-prone math.
> > diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
[]
> > @@ -287,7 +287,7 @@ l1oip_socket_send(struct l1oip *hc, u8 localcodec, u8 channel, u32 chanmask,
> >   	p = frame;
> >
> >   	/* restart timer */
> > -	if ((int)(hc->keep_tl.expires-jiffies) < 5 * HZ) {
> > +	if (time_before(hc->keep_tl.expires - 5 * HZ, jiffies)) {
> 
>     Wouldn't it be clearer this way:
> 
> 	if (time_before(hc->keep_tl.expires, jiffies + 5 * HZ)) {

> >   		del_timer(&hc->keep_tl);
> >   		hc->keep_tl.expires = jiffies + L1OIP_KEEPALIVE * HZ;
> >   		add_timer(&hc->keep_tl);

mod_timer?


