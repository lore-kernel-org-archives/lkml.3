Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753066AbaIBKaR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 06:30:17 -0400
Received: from mga11.intel.com ([192.55.52.93]:5509 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750863AbaIBKaP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 06:30:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,448,1406617200"; 
   d="scan'208";a="593277687"
Date: Tue, 2 Sep 2014 13:30:11 +0300
From: Laurentiu Palcu <laurentiu.palcu@intel.com>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Joe Perches <joe@perches.com>
Cc: Jonathan Cameron <jic23@kernel.org>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>, linux-iio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/3] iio: accel: BMC150: add support for other Bosch
 chips
Message-ID: <20140902103010.GF12606@lpalcu-linux>
References: <1409301488-22166-4-git-send-email-laurentiu.palcu@intel.com>
 <1409562698-13202-1-git-send-email-laurentiu.palcu@intel.com>
 <1409585783.2664.18.camel@joe-AO725>
 <1409586696.3318.11.camel@spandruv-hsb-test>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409586696.3318.11.camel@spandruv-hsb-test>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 08:51:36AM -0700, Srinivas Pandruvada wrote:
> On Mon, 2014-09-01 at 08:36 -0700, Joe Perches wrote:
> > On Mon, 2014-09-01 at 12:11 +0300, Laurentiu Palcu wrote:
> > > The following chips are either similar or have only the resolution
> > > different. Hence, change this driver to support these chips too:
> > > 
> > > BMI055  - combo chip (accelerometer part is identical to BMC150's)
> > > BMA255  - identical to BMC150's accelerometer
> > > BMA222E - 8 bit resolution
> > > BMA250E - 10 bit resolution
> > > BMA280  - 14 bit resolution
> > > 
> > > Additionally:
> > >  * add bmc150_accel_match_acpi_device() function to check that the device
> > >    has been enumerated through ACPI;
> > >  * rename bmc150_accel_acpi_gpio_probe() to bmc150_accel_gpio_probe()
> > >    since the ACPI matching has been moved to the new function.  Also, this
> > >    will allow for the GPIO matching to be done against a device tree too, not only
> > >    ACPI tree;
> > []
> > > diff --git a/drivers/iio/accel/bmc150-accel.c b/drivers/iio/accel/bmc150-accel.c
> > []
> > > @@ -647,12 +659,13 @@ static int bmc150_accel_read_raw(struct iio_dev *indio_dev,
> > >  		{
> > >  			int i;
> > >  
> > > -			for (i = 0; i < ARRAY_SIZE(bmc150_accel_scale_table);
> > > -									 ++i) {
> > > -				if (bmc150_accel_scale_table[i].range ==
> > > +			for (i = 0;
> > > +			     i < ARRAY_SIZE(data->chip_info->scale_table);
> > > +			     ++i) {
> > > +				if (data->chip_info->scale_table[i].range ==
> > >  								data->range) {
> > >  					*val2 =
> > > -					bmc150_accel_scale_table[i].scale;
> > > +					data->chip_info->scale_table[i].scale;
> > >  					return IIO_VAL_INT_PLUS_MICRO;
> > >  				}
> > >  			}
> > 
> > This looks like it would read a lot better with
> > a temporary for data->chip_info->scale_table[i]
> > 
> > so these could become:
> > 
> > 			for (i = 0; i < etc; i++) {
> > 				type *temp = &data->chip_info->scale_table[i];
> > 				if (temp->range == data->range) {
> > 					*val2 = temp->scale;
> > 					return IIO_VAL_INT_PLUS_MICRO;
> > 				}
Rewrote this part in v5. Thanks for the suggestion.

> > 
> > Maybe all the bmc150_ variable names could be removed.
> > The prefixes don't seem to serve a purpose other than
> > to make the code longer.
> > 
> > The filename could be changed to be more generic.
> Then this will also require change in the CONFIG name to match. This
> will require all current users to change the config file once they
> update to new version of the driver, which they don't like to change
> once product config is finalized. Since the most of the chips will just
> differ by a number at the end and they may not be compatible to each
> other, finding a common name will be challenge.
> Instead the CONFIG description for this module should explicitly state
> the names of chips it is compatible to.
v5 contains the changed CONFIG description that includes the new added chips.

thanks,
laurentiu

