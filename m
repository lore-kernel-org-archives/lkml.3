Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab3JXSnp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 14:43:45 -0400
Received: from smtprelay0138.hostedemail.com ([216.40.44.138]:42436 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754747Ab3JXSnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 14:43:43 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::::::::,RULES_HIT:41:355:379:541:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1981:2110:2194:2199:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3868:3871:3872:3874:4250:4321:5007:7652:8828:10004:10400:10848:1
X-HE-Tag: crown83_2003eed3c7b5a
X-Filterd-Recvd-Size: 2518
Message-ID: <1382640218.22433.71.camel@joe-AO722>
Subject: Re: [PATCH 4/8] input: Remove OOM message after
 input_allocate_device
From: Joe Perches <joe@perches.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Kukjin Kim <kgene.kim@samsung.com>,
        Ferruh Yigit <fery@cypress.com>, Wan ZongShun <mcuos.com@gmail.com>,
        Andrey Moiseev <o2g.org.ru@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Josh Wu <josh.wu@atmel.com>, linux-samsung-soc@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, Ben Dooks <ben-linux@fluff.org>,
        linux-input@vger.kernel.org, Pau Oliva Fora <pof@eslack.org>,
        linux-arm-kernel@lists.infradead.org
Date: Thu, 24 Oct 2013 11:43:38 -0700
In-Reply-To: <20131024182611.GA3512@pengutronix.de>
References: <cover.1382555436.git.joe@perches.com>
	 <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
	 <20131024182611.GA3512@pengutronix.de>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-24 at 20:26 +0200, Uwe Kleine-König wrote:
> Hello Joe,
> 
> On Wed, Oct 23, 2013 at 12:14:50PM -0700, Joe Perches wrote:
> > Emitting an OOM message isn't necessary after input_allocate_device
> > as there's a generic OOM and a dump_stack already done.
> > 
> > [...]
> > Signed-off-by: Joe Perches <joe@perches.com>
> > diff --git a/drivers/input/joystick/as5011.c b/drivers/input/joystick/as5011.c
> > index 005d852..3b9c709 100644
> > --- a/drivers/input/joystick/as5011.c
> > +++ b/drivers/input/joystick/as5011.c
> > @@ -254,8 +254,6 @@ static int as5011_probe(struct i2c_client *client,
> >  	as5011 = kmalloc(sizeof(struct as5011_device), GFP_KERNEL);
> >  	input_dev = input_allocate_device();
> >  	if (!as5011 || !input_dev) {
> > -		dev_err(&client->dev,
> > -			"Can't allocate memory for device structure\n");
> Don't know if that can happen, but if as5011 is NULL but input_dev isn't
> the message would still be sensible, wouldn't it? There are several more
> that suffer the same "problem".

Any k.alloc without __GFP_NOWARN does a generic OOM message
and a dump_stack() so there could already be 2 messages anyway.

cheers, Joe

