Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564AbaCECEw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 21:04:52 -0500
Received: from smtprelay0076.hostedemail.com ([216.40.44.76]:41118 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753299AbaCECEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 21:04:51 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1431:1437:1515:1516:1518:1534:1540:1593:1594:1711:1730:1747:1777:1792:1801:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3874:4250:4321:4605:5007:7652:9121:10004:10400:10848:11026:11232:11658:11914:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: heart07_d1ab53f37244
X-Filterd-Recvd-Size: 1893
Message-ID: <1393985087.3271.21.camel@joe-AO722>
Subject: Re: [PATCH] gpio: clamp returned values to the boolean range
From: Joe Perches <joe@perches.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Alexandre Courbot <acourbot@nvidia.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Date: Tue, 04 Mar 2014 18:04:47 -0800
In-Reply-To: <CACRpkdY-oBdxxWhsGraEU31qyu+RWJAiRA+KEip6QNW3jRwGUA@mail.gmail.com>
References: <1393378800-7220-1-git-send-email-acourbot@nvidia.com>
	 <CACRpkdY-oBdxxWhsGraEU31qyu+RWJAiRA+KEip6QNW3jRwGUA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-03-05 at 09:49 +0800, Linus Walleij wrote:
> On Wed, Feb 26, 2014 at 9:40 AM, Alexandre Courbot <acourbot@nvidia.com> wrote:
> 
> > Nothing prevents GPIO drivers from returning values outside the
> > boolean range, and as it turns out a few drivers are actually doing so.
> > These values were passed as-is to unsuspecting consumers and created
> > confusion.
> >
> > This patch makes the internal _gpiod_get_raw_value() function return a
> > bool, effectively clamping the GPIO value to the boolean range no
> > matter what the driver does.
> 
> No, that will not be the semantic effect of this patch, bool is just
> another name for an int, maybe some static checkers will be able
> to use it however.

No, a bool is not an int.

It's really different.
include/linux/types.h:typedef _Bool                     bool;


