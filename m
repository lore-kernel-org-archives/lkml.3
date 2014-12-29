Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaL2PGB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 10:06:01 -0500
Received: from mga14.intel.com ([192.55.52.115]:39596 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834AbaL2PF7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 10:05:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,691,1406617200"; 
   d="scan'208";a="505298791"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dogaru, Vlad" <vlad.dogaru@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald" <pmeerw@pmeerw.net>
Subject: RE: [PATCH 4/8] iio: core: Introduce IO_CHAN_INFO_CALIBWEIGHT
Thread-Topic: [PATCH 4/8] iio: core: Introduce IO_CHAN_INFO_CALIBWEIGHT
Thread-Index: AQHQIRBLkL//7/2Es0ujJfhdPSIRcpymrCyA
Date: Mon, 29 Dec 2014 15:05:48 +0000
Deferred-Delivery: Mon, 29 Dec 2014 15:05:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199F7B06@irsmsx105.ger.corp.intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
 <1419029879-12024-5-git-send-email-irina.tirdea@intel.com>
 <549D632E.4000004@kernel.org>
In-Reply-To: <549D632E.4000004@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.180]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jonathan Cameron [mailto:jic23@kernel.org]
> Sent: 26 December, 2014 15:31
> To: Tirdea, Irina; linux-iio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
> Subject: Re: [PATCH 4/8] iio: core: Introduce IO_CHAN_INFO_CALIBWEIGHT
> 
> On 19/12/14 22:57, Irina Tirdea wrote:
> > Some devices need the weight of the user to compute other
> > parameters. One of this devices is Freescale's MMA9553L
> > (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> > that needs the weight of the user to compute the number of calories burnt.
> >
> > Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> > ---
> >  Documentation/ABI/testing/sysfs-bus-iio |    7 +++++++
> >  drivers/iio/industrialio-core.c         |    1 +
> >  include/linux/iio/iio.h                 |    1 +
> >  3 files changed, 9 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> > index 07acef7..e480175 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-iio
> > +++ b/Documentation/ABI/testing/sysfs-bus-iio
> > @@ -351,6 +351,13 @@ Description:
> >  		to compute the stride length, distance, speed and activity
> >  		type.
> >
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibweight
> > +KernelVersion:	3.19
> > +Contact:	linux-iio@vger.kernel.org
> > +Description:
> > +		Weight of the user (in kg). It is needed by some pedometers
> > +		to compute the calories burnt by the user.
> How about grams?  Nice to keep to SI units going forward (I appreciate we
> have broken that for what seemed like good reasons at the time) in one
> or two places, but it makes it much harder to define consistent interfaces in the
> long run.

According to SI [1] kg is the base unit for mass, so this was the obvious first choice.
I have nothing against using grams, but it is not clear to me why using grams would make it easier to define consistent interfaces in the long run.
I am probably missing something, so could you please clarify this?

Thanks,
Irina

[1] http://www.bipm.org/en/measurement-units/

> J
> > +
> >  What:		/sys/bus/iio/devices/iio:deviceX/in_accel_scale_available
> >  What:		/sys/.../iio:deviceX/in_voltageX_scale_available
> >  What:		/sys/.../iio:deviceX/in_voltage-voltage_scale_available
> > diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> > index 5e50aca..4c435c8 100644
> > --- a/drivers/iio/industrialio-core.c
> > +++ b/drivers/iio/industrialio-core.c
> > @@ -124,6 +124,7 @@ static const char * const iio_chan_info_postfix[] = {
> >  	[IIO_CHAN_INFO_INT_TIME] = "integration_time",
> >  	[IIO_CHAN_INFO_ENABLE] = "en",
> >  	[IIO_CHAN_INFO_CALIBHEIGHT] = "calibheight",
> > +	[IIO_CHAN_INFO_CALIBWEIGHT] = "calibweight",
> >  };
> >
> >  /**
> > diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> > index 878d861..752a929 100644
> > --- a/include/linux/iio/iio.h
> > +++ b/include/linux/iio/iio.h
> > @@ -40,6 +40,7 @@ enum iio_chan_info_enum {
> >  	IIO_CHAN_INFO_INT_TIME,
> >  	IIO_CHAN_INFO_ENABLE,
> >  	IIO_CHAN_INFO_CALIBHEIGHT,
> > +	IIO_CHAN_INFO_CALIBWEIGHT,
> >  };
> >
> >  enum iio_shared_by {
> >

