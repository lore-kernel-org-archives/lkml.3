Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405AbaJUB2F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 21:28:05 -0400
Received: from eusmtp01.atmel.com ([212.144.249.242]:24202 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaJUB2C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 21:28:02 -0400
From: "Yang, Wenyou" <Wenyou.Yang@atmel.com>
To: Kevin Hilman <khilman@kernel.org>
CC: "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "Desroches, Ludovic" <Ludovic.Desroches@atmel.com>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ferre, Nicolas" <Nicolas.FERRE@atmel.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 2/3] i2c/at91: add support for system PM
Thread-Topic: [PATCH 2/3] i2c/at91: add support for system PM
Thread-Index: AQHP7JHbyJ6iu2Gjukm0fxmxw0NHXpw5u1WA
Date: Tue, 21 Oct 2014 01:25:07 +0000
Message-ID: <B256D81BAE5131468A838E5D7A243641BF596753@penmbx01>
References: <1413776535-10123-1-git-send-email-wenyou.yang@atmel.com>
	<1413776535-10123-3-git-send-email-wenyou.yang@atmel.com>
 <7h8ukafvzm.fsf@deeprootsystems.com>
In-Reply-To: <7h8ukafvzm.fsf@deeprootsystems.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.168.5.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kevin,

> -----Original Message-----
> From: Kevin Hilman [mailto:khilman@kernel.org]
> Sent: Tuesday, October 21, 2014 2:16 AM
> To: Yang, Wenyou
> Cc: wsa@the-dreams.de; Desroches, Ludovic; linux-i2c@vger.kernel.org; linux-
> kernel@vger.kernel.org; Ferre, Nicolas; linux-arm-kernel@lists.infradead.org
> Subject: Re: [PATCH 2/3] i2c/at91: add support for system PM
> 
> Wenyou Yang <wenyou.yang@atmel.com> writes:
> 
> Add a changelog here describing what you're doing, and why.
> 
> > Signed-off-by: Wenyou Yang <wenyou.yang@atmel.com>
> > ---
> >  drivers/i2c/busses/i2c-at91.c |   30 ++++++++++++++++++++++++++++++
> >  1 file changed, 30 insertions(+)
> >
> > diff --git a/drivers/i2c/busses/i2c-at91.c
> > b/drivers/i2c/busses/i2c-at91.c index 03b9f48..8f408f8 100644
> > --- a/drivers/i2c/busses/i2c-at91.c
> > +++ b/drivers/i2c/busses/i2c-at91.c
> > @@ -845,6 +845,35 @@ static int at91_twi_remove(struct platform_device
> > *pdev)  }
> >
> >  #ifdef CONFIG_PM
> > +#ifdef CONFIG_PM_SLEEP
> > +static int at91_twi_suspend(struct device *dev) {
> > +	struct at91_twi_dev *twi_dev = dev_get_drvdata(dev);
> > +
> > +	if (!pm_runtime_suspended(dev))
> > +		clk_disable_unprepare(twi_dev->clk);
> 
> I would just call at91_twi_runtime_suspend() here.
> 
> Then, if you need to add additional steps, you only have to add them in once
> place.  This also makes it obvious that ->suspend and
> ->runtime_suspend are doing the exact same thing.
> 
> NOTE: you'll need to wrap the runtime_suspend|resume functions in just
> CONFIG_PM instead of CONFIG_PM_RUNTIME for this to work.
Thanks a lot, I will modify it.

> 
> Kevin

Best Regards,
Wenyou Yang
