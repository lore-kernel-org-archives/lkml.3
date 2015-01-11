Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbbAKNoU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2015 08:44:20 -0500
Received: from mga01.intel.com ([192.55.52.88]:63818 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752068AbbAKNoS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2015 08:44:18 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,737,1413270000"; 
   d="scan'208";a="635642982"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dogaru, Vlad" <vlad.dogaru@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald" <pmeerw@pmeerw.net>
Subject: RE: [PATCH 1/8] iio: core: Introduce CALORIES channel type
Thread-Topic: [PATCH 1/8] iio: core: Introduce CALORIES channel type
Thread-Index: AQHQIQ+QQuXaI2o/kE29ew9n0fZJ3ZymoTEQgAR4WoCAD+03kA==
Date: Sun, 11 Jan 2015 13:44:13 +0000
Deferred-Delivery: Sun, 11 Jan 2015 13:44:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199FDDC4@irsmsx105.ger.corp.intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
 <1419029879-12024-2-git-send-email-irina.tirdea@intel.com>
 <549D61F3.3030302@kernel.org>
 <1F3AC3675D538145B1661F571FE1805F199F7ADF@irsmsx105.ger.corp.intel.com>
 <54A5218D.1070204@kernel.org>
In-Reply-To: <54A5218D.1070204@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jonathan Cameron [mailto:jic23@kernel.org]
> Sent: 01 January, 2015 12:30
> To: Tirdea, Irina; linux-iio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
> Subject: Re: [PATCH 1/8] iio: core: Introduce CALORIES channel type
> 
> On 29/12/14 14:42, Tirdea, Irina wrote:
> >
> >
> >> -----Original Message-----
> >> From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-owner@vger.kernel.org] On Behalf Of Jonathan Cameron
> >> Sent: 26 December, 2014 15:26
> >> To: Tirdea, Irina; linux-iio@vger.kernel.org
> >> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
> >> Subject: Re: [PATCH 1/8] iio: core: Introduce CALORIES channel type
> >>
> >> On 19/12/14 22:57, Irina Tirdea wrote:
> >>> Some devices compute the number of calories that the user has
> >>> burnt since the last reset.
> >>>
> >>> One of this devices is Freescale's MMA9553L
> >>> (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> >>> that computes the number of calories based on weight and step rate.
> >>>
> >>> Introduce a new channel type CALORIES to export these values.
> >>>
> >>> Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> >> hmm..  Ideally we use SI units for everything, but in human energy usage
> >> Calories are the most common unit by a long way.  I'm having some trouble
> >> even finding the conversion for this particular for of calorie.
> >>
> >
> > Initially I wanted to use the calorie as unit, but it seemed a little bit confusing because there are 2 different units both called calorie:
> > - The small calorie or gram calorie approximates the energy needed to increase the temperature of 1 gram of water by 1 C.
> > - The kilogram calorie or "large calorie" is an obsolete term used for the kilocalorie, which is the calorie used to express the energy
> content of foods. However, in practice, the prefix "kilo" is usually omitted.
> >
> oops. I didn't actually read the patch beyond seeing CALORIES as the type in the title ;)
> > Instead of using cal (small calorie), kcal or Calorie (large calorie) as unit, I think it would be more clear to use Joule since that would
> eliminate confusion and it is also a SI unit.
> >
> > According to the conversion table from here http://physics.nist.gov/Pubs/SP811/appenB9.html#ENERGY, we could convert
> nutritional calories to Joules using the following formula:
> >   Energy (Joules) = 4 184 * calories_th_nutrition
> > I used this formula in the implementation of the driver.
> Joules is good, but then the type needs to be ENERGY rather than CALORIES.
> (and in_energy_* etc).


That sounds better. Will change the type to ENERGY.

> >
> >> Now clearly it doesn't matter if the only energy sensors we ever get
> >> are for human activity. However, that's unlikely to be the case.  We
> >> already have devices doing instantaneous power and there are plenty
> >> of smart meter chips out there (though of course, they will use the
> >> option of kW Hours just to confuse matters).
> >>
> >> I'd definitely prefer joules if we can do it with out a large amount of
> >> pain.
> >>
> >> Lars - any views on this?  (Analog do make plenty of 'energy' measurement
> >> devices after all!)
> >>> ---
> >>>  Documentation/ABI/testing/sysfs-bus-iio |    9 +++++++++
> >>>  drivers/iio/industrialio-core.c         |    1 +
> >>>  include/linux/iio/types.h               |    1 +
> >>>  3 files changed, 11 insertions(+)
> >>>
> >>> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> >>> index df5e69e..bb9342b 100644
> >>> --- a/Documentation/ABI/testing/sysfs-bus-iio
> >>> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> >>> @@ -282,6 +282,7 @@ What:		/sys/bus/iio/devices/iio:deviceX/in_current_scale
> >>>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale
> >>>  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_peak_scale
> >>>  What:		/sys/bus/iio/devices/iio:deviceX/in_anglvel_scale
> >>> +What:		/sys/bus/iio/devices/iio:deviceX/in_calories_scale
> >>>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_scale
> >>>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_x_scale
> >>>  What:		/sys/bus/iio/devices/iio:deviceX/in_magn_y_scale
> >>> @@ -1049,6 +1050,14 @@ Description:
> >>>  		For a list of available output power modes read
> >>>  		in_accel_power_mode_available.
> >>>
> >>> +What:		/sys/.../iio:deviceX/in_calories_input
> >>> +What:		/sys/.../iio:deviceX/in_calories_raw
> >>> +KernelVersion:	3.17
> >>> +Contact:	linux-iio@vger.kernel.org
> >>> +Description:
> >>> +		This attribute is used to read the number of calories burned since the last
> >>> +		reset. Units after application of scale are Joules.
> >>> +
> >>>  What:		/sys/bus/iio/devices/iio:deviceX/store_eeprom
> >>>  KernelVersion:	3.4.0
> >>>  Contact:	linux-iio@vger.kernel.org
> >>> diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> >>> index ee442ee..5d95e84 100644
> >>> --- a/drivers/iio/industrialio-core.c
> >>> +++ b/drivers/iio/industrialio-core.c
> >>> @@ -72,6 +72,7 @@ static const char * const iio_chan_type_name_spec[] = {
> >>>  	[IIO_HUMIDITYRELATIVE] = "humidityrelative",
> >>>  	[IIO_ACTIVITY] = "activity",
> >>>  	[IIO_STEPS] = "steps",
> >>> +	[IIO_CALORIES] = "calories",
> >>>  };
> >>>
> >>>  static const char * const iio_modifier_names[] = {
> >>> diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> >>> index 904dcbb..d2fe930 100644
> >>> --- a/include/linux/iio/types.h
> >>> +++ b/include/linux/iio/types.h
> >>> @@ -32,6 +32,7 @@ enum iio_chan_type {
> >>>  	IIO_HUMIDITYRELATIVE,
> >>>  	IIO_ACTIVITY,
> >>>  	IIO_STEPS,
> >>> +	IIO_CALORIES,
> >>>  };
> >>>
> >>>  enum iio_modifier {
> >>>
> >>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-iio" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html

