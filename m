Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab3CPNdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 09:33:46 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59185 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755743Ab3CPNdp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 09:33:45 -0400
X-Originating-IP: 108.223.40.66
Date: Sat, 16 Mar 2013 06:33:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [ 11/21] hwmon: (sht15) Check return value of regulator_enable()
Message-ID: <20130316133352.GA25567@roeck-us.net>
References: <20130312223245.109098379@linuxfoundation.org>
 <20130312223246.431610777@linuxfoundation.org>
 <1363407324.3937.169.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1363407324.3937.169.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 16, 2013 at 04:15:24AM +0000, Ben Hutchings wrote:
> On Tue, 2013-03-12 at 15:44 -0700, Greg Kroah-Hartman wrote:
> > 3.0-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > 
> > commit 3e78080f81481aa8340374d5a37ae033c1cf4272 upstream.
> > 
> > Not having power is a pretty serious error so check that we are able to
> > enable the supply and error out if we can't.
> > 
> > Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> > ---
> >  drivers/hwmon/sht15.c |    8 +++++++-
> >  1 file changed, 7 insertions(+), 1 deletion(-)
> > 
> > --- a/drivers/hwmon/sht15.c
> > +++ b/drivers/hwmon/sht15.c
> > @@ -926,7 +926,13 @@ static int __devinit sht15_probe(struct
> >  		if (voltage)
> >  			data->supply_uV = voltage;
> >  
> > -		regulator_enable(data->reg);
> > +		ret = regulator_enable(data->reg);
> > +		if (ret != 0) {
> > +			dev_err(&pdev->dev,
> > +				"failed to enable regulator: %d\n", ret);
> > +			return ret;
> > +		}
> > +
> >  		/*
> >  		 * Setup a notifier block to update this if another device
> >  		 * causes the voltage to change
> 
> Since this has now been released, I think you need this follow-up fix in
> 3.0.y and 3.4.y:
> 
Excellent catch. I submitted your patch to -stable.

Thanks,
Guenter
