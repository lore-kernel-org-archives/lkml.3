Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752769AbaJFNue (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 09:50:34 -0400
Received: from mga03.intel.com ([134.134.136.65]:32524 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752691AbaJFNua convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 09:50:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,664,1406617200"; 
   d="scan'208";a="584127134"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: "Baluta, Daniel" <daniel.baluta@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 4/8] iio: core: Introduce pedometer STEP counter
 modifier
Thread-Topic: [RFC PATCH 4/8] iio: core: Introduce pedometer STEP counter
 modifier
Thread-Index: AQHP39IqO8PzZJcz2UyGrX1QEK4nhZwjD6NA
Date: Mon, 6 Oct 2014 13:50:13 +0000
Deferred-Delivery: Mon, 6 Oct 2014 13:50:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199AD91D@IRSMSX105.ger.corp.intel.com>
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
 <1412257439-15683-5-git-send-email-daniel.baluta@intel.com>
 <542FEDB7.3050302@kernel.org>
In-Reply-To: <542FEDB7.3050302@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.182]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jonathan Cameron [mailto:jic23@kernel.org]
> On 02/10/14 14:43, Daniel Baluta wrote:
> > From: Irina Tirdea <irina.tirdea@intel.com>
> >
> > One of the functionalities of a pedometer is a step counter.
> > The step counter needs to be enabled and then it will count the steps
> > in its hardware register. Whenever the applications need to check
> > the step count, they will read the step counter register.
> >
> > To support this functionality we need a steps attribute that
> > will export the number of steps.
> >
> I'm not keen on multiplexing different types of data onto a single activity type.
> Steps is well enough defined on it's own to have it's own channel type.
> 
> in_steps_input would be fine by me.  I suppose steps might mean something else
> though...
> 

Hi Jonathan,

Thanks for the review.

Moving the pedometer part to a new type sounds good to me.
However, I would prefer to add a new type called pedometer and keep steps as a modifier, generating names like in_ped_steps_input for the attribute and in_ped_steps_instance_en for the event.
The reason for this is that for supporting Freescale's MMA9553L we will need additional attributes (distance, speed, calories, height, weight) that we can add as modifiers to this pedometer type. To keep things simple, I did not add these additional attributes to the RFC series, but I could do that if you think it would be useful. For this device, the motion events (walking, running, jogging, still) also depend on the height attribute being set, but we intend to deal with this dependency in the driver (using the pedometer's height attribute).

What do you think?

Thanks,
Irina


> > --- a/drivers/iio/industrialio-core.c
> > +++ b/drivers/iio/industrialio-core.c
> > @@ -96,6 +96,7 @@ static const char * const iio_modifier_names[] = {
> >  	[IIO_MOD_JOGGING] = "jogging",
> >  	[IIO_MOD_WALKING] = "walking",
> >  	[IIO_MOD_STILL] = "still",
> > +	[IIO_MOD_PED_STEPS] = "steps",
> >  };
> >
> >  /* relies on pairs of these shared then separate */
> > diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
> > index 003638d..ae51780 100644
> > --- a/include/linux/iio/types.h
> > +++ b/include/linux/iio/types.h
> > @@ -65,6 +65,7 @@ enum iio_modifier {
> >  	IIO_MOD_JOGGING,
> >  	IIO_MOD_WALKING,
> >  	IIO_MOD_STILL,
> > +	IIO_MOD_PED_STEPS,
> >  };
> >
> >  enum iio_event_type {
> >
