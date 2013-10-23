Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752593Ab3JWTiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 15:38:22 -0400
Received: from smtprelay0021.hostedemail.com ([216.40.44.21]:56705 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751447Ab3JWTiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 15:38:20 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::,RULES_HIT:41:355:379:541:599:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2553:2559:2562:2693:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3871:3872:3873:4250:4321:5007:6119:7652:8700:10004:10400:10848:11026:11232:11658:11914:12043:12296:12438:12517:12519:12740:13069:13095:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:fn,MSBL:0,DNSBL:none,Custom_rules:0:0:0
X-HE-Tag: hat25_e14738b23941
X-Filterd-Recvd-Size: 2233
Message-ID: <1382557094.22433.40.camel@joe-AO722>
Subject: Re: [PATCHv4 2/3] Input: twl4030-pwrbutton: use dev_err for errors
From: Joe Perches <joe@perches.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Sachin Kamat <sachin.kamat@linaro.org>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Date: Wed, 23 Oct 2013 12:38:14 -0700
In-Reply-To: <20131023193112.GB30437@earth.universe>
References: <1382550852-11508-1-git-send-email-sre@debian.org>
	 <1382550852-11508-3-git-send-email-sre@debian.org>
	 <1382552266.22433.36.camel@joe-AO722>
	 <20131023193112.GB30437@earth.universe>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-10-23 at 21:31 +0200, Sebastian Reichel wrote:
> On Wed, Oct 23, 2013 at 11:17:46AM -0700, Joe Perches wrote:
> > On Wed, 2013-10-23 at 19:54 +0200, Sebastian Reichel wrote:
> > > Use dev_err() to output errors instead of dev_dbg().
> > []
> > > diff --git a/drivers/input/misc/twl4030-pwrbutton.c b/drivers/input/misc/twl4030-pwrbutton.c
> > []
> > > @@ -60,7 +60,7 @@ static int twl4030_pwrbutton_probe(struct platform_device *pdev)
> > >  
> > >  	pwr = input_allocate_device();
> > >  	if (!pwr) {
> > > -		dev_dbg(&pdev->dev, "Can't allocate power button\n");
> > > +		dev_err(&pdev->dev, "Can't allocate power button\n");
> > >  		return -ENOMEM;
> > >  	}
> > 
> > input_allocate_device uses kzalloc and it will emit a
> > standardized OOM message along with a dump_stack()
> > so this dev_err/dev_dbg is redundant and not necessary.
> 
> I saw you sent a big patchset changing this for all drivers.
> Should I drop this patch?

I think the 2 other bits of this patch are fine.
Maybe resend with this section dropped?

