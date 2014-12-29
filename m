Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283AbaL2T72 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 14:59:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:17533 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751505AbaL2T70 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 14:59:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,660,1413270000"; 
   d="scan'208";a="644243301"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dogaru, Vlad" <vlad.dogaru@intel.com>,
        "Baluta, Daniel" <daniel.baluta@intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Lars-Peter Clausen <lars@metafoo.de>,
        "Peter Meerwald" <pmeerw@pmeerw.net>
Subject: RE: [PATCH 5/8] iio: core: Introduce IIO_CHAN_INFO_CALIBGENDER
Thread-Topic: [PATCH 5/8] iio: core: Introduce IIO_CHAN_INFO_CALIBGENDER
Thread-Index: AQHQIRAL+wGQK2gBvEaJQi6Yv/S61pym5A1g
Date: Mon, 29 Dec 2014 19:59:23 +0000
Deferred-Delivery: Mon, 29 Dec 2014 19:59:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199F7B9F@irsmsx105.ger.corp.intel.com>
References: <1419029879-12024-1-git-send-email-irina.tirdea@intel.com>
 <1419029879-12024-6-git-send-email-irina.tirdea@intel.com>
 <549D62D2.5000105@kernel.org>
In-Reply-To: <549D62D2.5000105@kernel.org>
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
> Sent: 26 December, 2014 15:30
> To: Tirdea, Irina; linux-iio@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org; Dogaru, Vlad; Baluta, Daniel; Hartmut Knaack; Lars-Peter Clausen; Peter Meerwald
> Subject: Re: [PATCH 5/8] iio: core: Introduce IIO_CHAN_INFO_CALIBGENDER
> 
> On 19/12/14 22:57, Irina Tirdea wrote:
> > Some devices need the gender of the user to compute various
> > parameters. One of this devices is Freescale's MMA9553L
> > (http://www.freescale.com/files/sensors/doc/ref_manual/MMA9553LSWRM.pdf)
> > that needs the gender of the user to compute distance, speed and activity type.
> >
> > Signed-off-by: Irina Tirdea <irina.tirdea@intel.com>
> 
> > ---
> >  Documentation/ABI/testing/sysfs-bus-iio |    8 ++++++++
> >  drivers/iio/industrialio-core.c         |    1 +
> >  include/linux/iio/iio.h                 |    1 +
> >  3 files changed, 10 insertions(+)
> >
> > diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/testing/sysfs-bus-iio
> > index e480175..3b68c2d 100644
> > --- a/Documentation/ABI/testing/sysfs-bus-iio
> > +++ b/Documentation/ABI/testing/sysfs-bus-iio
> > @@ -343,6 +343,14 @@ Description:
> >  		production inaccuracies).  If shared across all channels,
> >  		<type>_calibscale is used.
> >
> > +What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibgender
> > +KernelVersion:	3.19
> > +Contact:	linux-iio@vger.kernel.org
> > +Description:
> > +		Gender of the user: 0 for female and 1 for male. It is needed
> > +		by some pedometers to compute the stride length, distance,
> > +		speed and activity type.
> This will have to go through the extended attribute enum interface. No magic
> numbers in the interface please.

Sure, I will change this in next version.

Thanks for the reviews, Jonathan!

Irina

> > +
> >  What:		/sys/bus/iio/devices/iio:deviceX/in_steps_calibheight
> >  KernelVersion:	3.19
> >  Contact:	linux-iio@vger.kernel.org
> > diff --git a/drivers/iio/industrialio-core.c b/drivers/iio/industrialio-core.c
> > index 4c435c8..93a39f9 100644
> > --- a/drivers/iio/industrialio-core.c
> > +++ b/drivers/iio/industrialio-core.c
> > @@ -125,6 +125,7 @@ static const char * const iio_chan_info_postfix[] = {
> >  	[IIO_CHAN_INFO_ENABLE] = "en",
> >  	[IIO_CHAN_INFO_CALIBHEIGHT] = "calibheight",
> >  	[IIO_CHAN_INFO_CALIBWEIGHT] = "calibweight",
> > +	[IIO_CHAN_INFO_CALIBGENDER] = "calibgender",
> >  };
> >
> >  /**
> > diff --git a/include/linux/iio/iio.h b/include/linux/iio/iio.h
> > index 752a929..63dac0f 100644
> > --- a/include/linux/iio/iio.h
> > +++ b/include/linux/iio/iio.h
> > @@ -41,6 +41,7 @@ enum iio_chan_info_enum {
> >  	IIO_CHAN_INFO_ENABLE,
> >  	IIO_CHAN_INFO_CALIBHEIGHT,
> >  	IIO_CHAN_INFO_CALIBWEIGHT,
> > +	IIO_CHAN_INFO_CALIBGENDER,
> >  };
> >
> >  enum iio_shared_by {
> >

