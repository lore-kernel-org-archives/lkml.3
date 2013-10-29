Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752014Ab3J2TiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 15:38:15 -0400
Received: from smtprelay0092.hostedemail.com ([216.40.44.92]:35075 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751246Ab3J2TiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 15:38:14 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::,RULES_HIT:41:355:379:541:599:960:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2194:2199:2393:2559:2562:2691:2828:2919:3138:3139:3140:3141:3142:3353:3622:3867:3868:3872:3873:3874:4321:4605:5007:6119:6120:7652:7901:7903:9036:9108:10004:10400:10848:11026:11232:11658:11914:12043:12517:12519:12663:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beam56_479813d677631
X-Filterd-Recvd-Size: 2358
Message-ID: <1383075490.12439.26.camel@joe-AO722>
Subject: Re: [PATCH 1/2] spi: add Intel Mid SSP driver
From: Joe Perches <joe@perches.com>
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: broonie@kernel.org, ning.li@intel.com, linux-kernel@vger.kernel.org,
        linux-spi@vger.kernel.org, Fei Yang <fei.yang@intel.com>
Date: Tue, 29 Oct 2013 12:38:10 -0700
In-Reply-To: <52700D4C.10008@linux.intel.com>
References: <1383069950-27754-1-git-send-email-david.a.cohen@linux.intel.com>
	 <1383070766.12439.13.camel@joe-AO722> <526FFED4.4070902@linux.intel.com>
	 <1383071755.12439.17.camel@joe-AO722> <52700D4C.10008@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-10-29 at 12:32 -0700, David Cohen wrote:
> On 10/29/2013 11:35 AM, Joe Perches wrote:
> > On Tue, 2013-10-29 at 11:30 -0700, David Cohen wrote:
> >> On 10/29/2013 11:19 AM, Joe Perches wrote:
> >>> On Tue, 2013-10-29 at 11:05 -0700, David Cohen wrote:
> >>>> This patch adds driver for ssp spi interface on Intel Mid platform.
> >>> A few simple notes:
> >>> Please consider using checkpatch.
> >> I did and got no warnings. But haven't used --strict option.
> > Interesting.  I thought there was a return (foo);
> > statement that should have been marked, but I didn't
> > actually run checkpatch.
> 
> It seems odd checkpatch didn't catch it. I'll investigate.

No need.  I believe I know why.
checkpatch doesn't use "$balanced_parens" checks for return
tests.  I'm not sure it's worth fixing right now, but it
could be tested as:

	if ($^V && $^V ge 5.10.0 &&
	    $stat =~ /^.\s*return\s*$balanced_parens\s*;\s*$/)

> > static inline u32 is_rx_fifo_empty(struct ssp_drv_context *sspc)
> > +{
> > +       return ((read_SSSR(sspc->ioaddr) & SSSR_RNE) == 0);
> > +}
> > This could be bool too
> u32 seems unusual, but I'd prefer 'int' if it's fine for you.

Anything is_<foo> that returns what seems to be true/false
I think could be bool.

But, no worries, it's your code.  Do what you think best.


