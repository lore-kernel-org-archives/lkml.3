Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762627Ab3ECHLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 03:11:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:58064 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762217Ab3ECHLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 03:11:47 -0400
Date: Fri, 3 May 2013 08:11:42 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
Subject: Re: [PATCH 4/4] staging: =?utf-8?Q?ste=5Fr?=
 =?utf-8?Q?mi4=3A_Suppress_'ignoring_return_value_of_=E2=80=98regulator=5F?=
 =?utf-8?B?ZW5hYmxlKCkn?= warning
Message-ID: <20130503071142.GB24153@gmail.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-5-git-send-email-lee.jones@linaro.org>
 <20130503070713.GA27956@bnru09>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130503070713.GA27956@bnru09>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 03 May 2013, Srinidhi Kasagar wrote:

> On Thu, May 02, 2013 at 17:48:10 +0200, Lee Jones wrote:
> > drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c:
> >         In function ‘synaptics_rmi4_resume’:
> > drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c:1090:18:
> >         warning: ignoring return value of ‘regulator_enable’, declared
> >         with attribute warn_unused_result [-Wunused-result
> > 
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: devel@driverdev.osuosl.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> > 
> > diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > index fe667dd..c4d013d 100644
> > --- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > +++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > @@ -1087,7 +1087,9 @@ static int synaptics_rmi4_resume(struct device *dev)
> >  	unsigned char intr_status;
> >  	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
> >  
> > -	regulator_enable(rmi4_data->regulator);
> > +	retval = regulator_enable(rmi4_data->regulator);
> > +	if (retval < 0)
> > +		return retval;
> Does it make sense to add a dev_err?

Yes, I can do that.

> Otherwise, you can add my
> Acked-by:srinidhi kasagar <srinidhi.kasagar@stericsson.com> for this series.

Thanks.

> >  
> >  	enable_irq(rmi4_data->i2c_client->irq);
> >  	rmi4_data->touch_stopped = false;

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
