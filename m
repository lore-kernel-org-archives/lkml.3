Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757264Ab3ENLFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:05:04 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:57670 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755921Ab3ENLFC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:05:02 -0400
Date: Tue, 14 May 2013 07:05:13 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com,
        srinidhi.kasagar@stericsson.com, devel@driverdev.osuosl.org
Subject: Re: [PATCH 4/4] staging: =?utf-8?Q?ste=5Fr?=
 =?utf-8?Q?mi4=3A_Suppress_'ignoring_return_value_of_=E2=80=98regulator=5F?=
 =?utf-8?B?ZW5hYmxlKCkn?= warning
Message-ID: <20130514110513.GA10354@kroah.com>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-5-git-send-email-lee.jones@linaro.org>
 <20130514104631.GA28781@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130514104631.GA28781@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 11:46:31AM +0100, Lee Jones wrote:
> Hi Greg,
> 
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
> >  
> >  	enable_irq(rmi4_data->i2c_client->irq);
> >  	rmi4_data->touch_stopped = false;
> 
> Are you planning to take this into the v3.10 -rcs?

Yes, I was, give me some time to catch up on my pending patch queue (644
patches and counting).  Don't worry, it's not lost.

thanks,

greg k-h
