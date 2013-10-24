Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756134Ab3JXSqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 14:46:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44724 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754939Ab3JXSqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 14:46:30 -0400
Date: Thu, 24 Oct 2013 20:46:12 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Joe Perches <joe@perches.com>
Cc: Kukjin Kim <kgene.kim@samsung.com>, Ferruh Yigit <fery@cypress.com>,
        Wan ZongShun <mcuos.com@gmail.com>,
        Andrey Moiseev <o2g.org.ru@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-kernel@vger.kernel.org, Josh Wu <josh.wu@atmel.com>,
        linux-samsung-soc@vger.kernel.org,
        Henrik Rydberg <rydberg@euromail.se>, Ben Dooks <ben-linux@fluff.org>,
        linux-input@vger.kernel.org, Pau Oliva Fora <pof@eslack.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 4/8] input: Remove OOM message after input_allocate_device
Message-ID: <20131024184612.GC3512@pengutronix.de>
References: <cover.1382555436.git.joe@perches.com>
 <cc5e6a317bc9ef33cfdfae3ed9d3a47b5319a47b.1382555436.git.joe@perches.com>
 <20131024182611.GA3512@pengutronix.de>
 <1382640218.22433.71.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1382640218.22433.71.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 11:43:38AM -0700, Joe Perches wrote:
> On Thu, 2013-10-24 at 20:26 +0200, Uwe Kleine-König wrote:
> > Hello Joe,
> > 
> > On Wed, Oct 23, 2013 at 12:14:50PM -0700, Joe Perches wrote:
> > > Emitting an OOM message isn't necessary after input_allocate_device
> > > as there's a generic OOM and a dump_stack already done.
> > > 
> > > [...]
> > > Signed-off-by: Joe Perches <joe@perches.com>
> > > diff --git a/drivers/input/joystick/as5011.c b/drivers/input/joystick/as5011.c
> > > index 005d852..3b9c709 100644
> > > --- a/drivers/input/joystick/as5011.c
> > > +++ b/drivers/input/joystick/as5011.c
> > > @@ -254,8 +254,6 @@ static int as5011_probe(struct i2c_client *client,
> > >  	as5011 = kmalloc(sizeof(struct as5011_device), GFP_KERNEL);
> > >  	input_dev = input_allocate_device();
> > >  	if (!as5011 || !input_dev) {
> > > -		dev_err(&client->dev,
> > > -			"Can't allocate memory for device structure\n");
> > Don't know if that can happen, but if as5011 is NULL but input_dev isn't
> > the message would still be sensible, wouldn't it? There are several more
> > that suffer the same "problem".
> 
> Any k.alloc without __GFP_NOWARN does a generic OOM message
> and a dump_stack() so there could already be 2 messages anyway.
Then mention that in the commit log if you still want this patch?!

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
