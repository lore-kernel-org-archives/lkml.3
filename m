Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927AbaLFEYe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 23:24:34 -0500
Received: from smtprelay0083.hostedemail.com ([216.40.44.83]:35606 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751052AbaLFEYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 23:24:31 -0500
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1538:1593:1594:1711:1714:1730:1747:1777:1792:2194:2199:2393:2559:2562:2828:3138:3139:3140:3141:3142:3351:3622:3865:3868:3871:3872:4321:5007:6119:6742:7652:7903:9036:10004:10400:10848:11026:11232:11658:11914:12517:12519:12663:12740:13019:13069:13311:13357:21080,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: beam68_7e47a58ffed59
X-Filterd-Recvd-Size: 2152
Message-ID: <1417839865.31745.10.camel@perches.com>
Subject: Re: [PATCH 2/5] gpio: Cygnus: add GPIO driver
From: Joe Perches <joe@perches.com>
To: Ray Jui <rjui@broadcom.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Christian Daudt <bcm@fixthebug.org>, Matt Porter <mporter@linaro.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Scott Branden <sbranden@broadcom.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-gpio@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, devicetree@vger.kernel.org
Date: Fri, 05 Dec 2014 20:24:25 -0800
In-Reply-To: <54827B07.3000707@broadcom.com>
References: <Ray Jui <rjui@broadcom.com>
	 <1417826408-1600-1-git-send-email-rjui@broadcom.com>
	 <1417826408-1600-3-git-send-email-rjui@broadcom.com>
	 <1417829282.31745.3.camel@perches.com> <5482668F.1040907@broadcom.com>
	 <1417833291.31745.5.camel@perches.com> <54827B07.3000707@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-12-05 at 19:41 -0800, Ray Jui wrote:
> On 12/5/2014 6:34 PM, Joe Perches wrote:
> > On Fri, 2014-12-05 at 18:14 -0800, Ray Jui wrote:
> >> On 12/5/2014 5:28 PM, Joe Perches wrote:
> >>> On Fri, 2014-12-05 at 16:40 -0800, Ray Jui wrote:
> >>>> +			for_each_set_bit(bit, &val, 32) {
[]
> Actually, by reviewing the code more deeply, I'm not sure why using 
> for_each_set_bit here is 'endian unsafe'.

It's not.  The 32 confused me as it was long
and sizeof(long) isn't necessarily 32.

Maybe the 32 should be a #define



