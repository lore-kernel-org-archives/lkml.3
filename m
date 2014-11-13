Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932534AbaKMKc3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 05:32:29 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:39212 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbaKMKc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 05:32:27 -0500
Date: Thu, 13 Nov 2014 10:32:20 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Laurentiu Palcu <laurentiu.palcu@intel.com>
Cc: Mark Brown <broonie@kernel.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Johan Havold <johan@kernel.org>,
        Octavian Purdila <octavian.purdila@intel.com>,
        linux-spi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mfd: dln2: add support for USB-SPI module
Message-ID: <20141113103220.GL24004@x1>
References: <1415364314-30320-1-git-send-email-laurentiu.palcu@intel.com>
 <1415364314-30320-3-git-send-email-laurentiu.palcu@intel.com>
 <20141110093005.GF21424@x1>
 <20141111130904.GN5826@lpalcu-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141111130904.GN5826@lpalcu-linux>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Nov 2014, Laurentiu Palcu wrote:

> Hi Lee,
> 
> On Mon, Nov 10, 2014 at 09:30:05AM +0000, Lee Jones wrote:
> > On Fri, 07 Nov 2014, Laurentiu Palcu wrote:
> > 
> > > Signed-off-by: Laurentiu Palcu <laurentiu.palcu@intel.com>
> > > ---
> > >  drivers/mfd/dln2.c | 12 ++++++++++++
> > >  1 file changed, 12 insertions(+)
> > > 
> > > diff --git a/drivers/mfd/dln2.c b/drivers/mfd/dln2.c
> > > index 9765a17..0cdad2d 100644
> > > --- a/drivers/mfd/dln2.c
> > > +++ b/drivers/mfd/dln2.c
> > > @@ -52,6 +52,7 @@ enum dln2_handle {
> > >  	DLN2_HANDLE_CTRL,
> > >  	DLN2_HANDLE_GPIO,
> > >  	DLN2_HANDLE_I2C,
> > > +	DLN2_HANDLE_SPI,
> > >  	DLN2_HANDLES
> > >  };
> > >  
> > > @@ -634,6 +635,12 @@ static struct dln2_platform_data dln2_pdata_i2c = {
> > >  	.port = 0,
> > >  };
> > >  
> > > +/* Only one SPI port supported */
> > > +static struct dln2_platform_data dln2_pdata_spi = {
> > 
> > Is this ever fiddled with?  If not, const?
> Well, if we declare this const we also need to cast the assignment below to
> void* since platform_data is void*. Otherwise we get a "assignment
> discards ‘const’ qualifier from pointer target type" warning. 
> 
> Also, for consistency, we have to do it for all dln2_pdata_*. I'm not
> sure it's worth it...

Yes, perhaps you are right.

Patch applied.

> > > +	.handle = DLN2_HANDLE_SPI,
> > > +	.port = 0,
> > > +};
> > > +
> > >  static const struct mfd_cell dln2_devs[] = {
> > >  	{
> > >  		.name = "dln2-gpio",
> > > @@ -645,6 +652,11 @@ static const struct mfd_cell dln2_devs[] = {
> > >  		.platform_data = &dln2_pdata_i2c,
> > >  		.pdata_size = sizeof(struct dln2_platform_data),
> > >  	},
> > > +	{
> > > +		.name = "dln2-spi",
> > > +		.platform_data = &dln2_pdata_spi,
> > > +		.pdata_size = sizeof(struct dln2_platform_data),
> > > +	},
> > >  };
> > >  
> > >  static void dln2_disconnect(struct usb_interface *interface)
> > 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
