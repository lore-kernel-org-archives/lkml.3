Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758535Ab3J2QYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:24:13 -0400
Received: from smtprelay0131.hostedemail.com ([216.40.44.131]:49527 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758512Ab3J2QYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:24:10 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1801:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3353:3622:3865:3866:3871:3872:3874:4321:4605:5007:7652:7903:9121:10004:10400:10848:11026:11232:11233:11658:11914:12296:12517:12519:12555:12740:13069:13311:13357:13972,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: bomb22_7b2c5be350121
X-Filterd-Recvd-Size: 2627
Message-ID: <1383063845.2713.15.camel@joe-AO722>
Subject: Re: [PATCH v2] can: c_can: Speed up rx_poll function
From: Joe Perches <joe@perches.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Tue, 29 Oct 2013 09:24:05 -0700
In-Reply-To: <20131029085853.GC20839@pengutronix.de>
References: <1383035267-19604-1-git-send-email-mpa@pengutronix.de>
	 <1383035688.2713.2.camel@joe-AO722> <20131029085853.GC20839@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 09:58 +0100, Markus Pargmann wrote:
> On Tue, Oct 29, 2013 at 01:34:48AM -0700, Joe Perches wrote:
> > On Tue, 2013-10-29 at 09:27 +0100, Markus Pargmann wrote:
> > > This patch speeds up the rx_poll function by reducing the number of
> > > register reads.
> > []
> > > 125kbit:
> > >   Function                               Hit    Time            Avg             s^2
> > >   --------                               ---    ----            ---             ---
> > >   c_can_do_rx_poll                     63960    10168178 us     158.977 us      1493056 us
> > > With patch:
> > >   c_can_do_rx_poll                     63939    4268457 us     66.758 us       818790.9 us
> > > 
> > > 1Mbit:
> > >   Function                               Hit    Time            Avg             s^2
> > >   --------                               ---    ----            ---             ---
> > >   c_can_do_rx_poll                     69489    30049498 us     432.435 us      9271851 us
> > > With patch:
> > >   c_can_do_rx_poll                    103034    24220362 us     235.071 us      6016656 us
[]
> Yes I just measured the timings again:
[]
> ./perf_can_test.sh 125000 30
[]
>   c_can_do_rx_poll                     63941    3764057 us     58.867 us       776162.2 us 

Good, it's slightly faster still.

> ./perf_can_test.sh 1000000 30
[]
>   c_can_do_rx_poll                    207109    24322185 us     117.436 us      171469047 us 
[]
> It is interesting that the number of hits for c_can_do_rx_poll is twice as much
> as it was with find_next_bit.

How is this possible?  Any idea?


