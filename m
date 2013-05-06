Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab3EFGxi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 02:53:38 -0400
Received: from eu1sys200aog120.obsmtp.com ([207.126.144.149]:51413 "EHLO
	eu1sys200aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab3EFGxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 02:53:36 -0400
Date: Mon, 6 May 2013 12:21:39 +0530
From: Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 4/4] staging: =?utf-8?Q?ste=5Fr?=
	=?utf-8?Q?mi4=3A_Suppress_'ignoring_return_value_of_=E2=80=98regulator=5F?=
	=?utf-8?B?ZW5hYmxlKCkn?= warning
Message-ID: <20130506065138.GA31763@bnru10>
References: <1367509690-24022-1-git-send-email-lee.jones@linaro.org>
 <1367509690-24022-5-git-send-email-lee.jones@linaro.org>
 <20130503070713.GA27956@bnru09>
 <20130505141855.GB4686@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130505141855.GB4686@mwanda>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 05, 2013 at 16:18:55 +0200, Dan Carpenter wrote:
> On Fri, May 03, 2013 at 12:37:14PM +0530, Srinidhi Kasagar wrote:
> > On Thu, May 02, 2013 at 17:48:10 +0200, Lee Jones wrote:
> > > drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c:
> > >         In function ‘synaptics_rmi4_resume’:
> > > drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c:1090:18:
> > >         warning: ignoring return value of ‘regulator_enable’, declared
> > >         with attribute warn_unused_result [-Wunused-result
> > > 
> > > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Cc: devel@driverdev.osuosl.org
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c |    4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > > index fe667dd..c4d013d 100644
> > > --- a/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > > +++ b/drivers/staging/ste_rmi4/synaptics_i2c_rmi4.c
> > > @@ -1087,7 +1087,9 @@ static int synaptics_rmi4_resume(struct device *dev)
> > >  	unsigned char intr_status;
> > >  	struct synaptics_rmi4_data *rmi4_data = dev_get_drvdata(dev);
> > >  
> > > -	regulator_enable(rmi4_data->regulator);
> > > +	retval = regulator_enable(rmi4_data->regulator);
> > > +	if (retval < 0)
> > > +		return retval;
> > Does it make sense to add a dev_err?
> > 
> 
> Is that a question?
> 
> regulator_enable() already prints some warnings.  Probably it's not
> going to fail and adding code that is duplicative or will never be
> run is pointless.

It has become a habit checking the return value and spit some errors.
And BTW, there are many drivers which does this way..Anyway if your
intention is to avoid them for the new drivers..I dont mind skipping
this..

regards/srinidhi


> 
> regards,
> dan carpenter
> 
