Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136AbaJFQbd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 12:31:33 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:43739 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751660AbaJFQbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 12:31:31 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <1F3AC3675D538145B1661F571FE1805F199AD91D@IRSMSX105.ger.corp.intel.com>
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com> <1412257439-15683-5-git-send-email-daniel.baluta@intel.com> <542FEDB7.3050302@kernel.org> <1F3AC3675D538145B1661F571FE1805F199AD91D@IRSMSX105.ger.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: RE: [RFC PATCH 4/8] iio: core: Introduce pedometer STEP counter modifier
From: Jonathan Cameron <jic23@kernel.org>
Date: Mon, 06 Oct 2014 17:31:21 +0100
To: "Tirdea, Irina" <irina.tirdea@intel.com>
CC: "Baluta, Daniel" <daniel.baluta@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-ID: <888C517D-6823-4FB5-870E-484DADAF5230@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On October 6, 2014 2:50:13 PM GMT+01:00, "Tirdea, Irina" <irina.tirdea@intel.com> wrote:
>> From: Jonathan Cameron [mailto:jic23@kernel.org]
>> On 02/10/14 14:43, Daniel Baluta wrote:
>> > From: Irina Tirdea <irina.tirdea@intel.com>
>> >
>> > One of the functionalities of a pedometer is a step counter.
>> > The step counter needs to be enabled and then it will count the
>steps
>> > in its hardware register. Whenever the applications need to check
>> > the step count, they will read the step counter register.
>> >
>> > To support this functionality we need a steps attribute that
>> > will export the number of steps.
>> >
>> I'm not keen on multiplexing different types of data onto a single
>activity type.
>> Steps is well enough defined on it's own to have it's own channel
>type.
>> 
>> in_steps_input would be fine by me.  I suppose steps might mean
>something else
>> though...
>> 
>
>Hi Jonathan,
>
>Thanks for the review.
>
>Moving the pedometer part to a new type sounds good to me.
>However, I would prefer to add a new type called pedometer and keep
>steps as a modifier, generating names like in_ped_steps_input for the
>attribute and in_ped_steps_instance_en for the event.
>The reason for this is that for supporting Freescale's MMA9553L we will
>need additional attributes (distance, speed, calories, height, weight)
>that we can add as modifiers to this pedometer type. To keep things
>simple, I did not add these additional attributes to the RFC series,
>but I could do that if you think it would be useful. For this device,
>the motion events (walking, running, jogging, still) also depend on the
>height attribute being set, but we intend to deal with this dependency
>in the driver (using the pedometer's height attribute).
>
>What do you think?
I think I would rather each of these was included as a type rather than a modifier.
There are lots of other ways to measure speed for starters and often user space
won't care where it comes from...

In_speed_raw etc...

Trick where possible is to think about what is measured rather than how. Tends to give
 more consistent interfaces.
>
>Thanks,
>Irina
>
>
>> > --- a/drivers/iio/industrialio-core.c
>> > +++ b/drivers/iio/industrialio-core.c
>> > @@ -96,6 +96,7 @@ static const char * const iio_modifier_names[] =
>{
>> >  	[IIO_MOD_JOGGING] = "jogging",
>> >  	[IIO_MOD_WALKING] = "walking",
>> >  	[IIO_MOD_STILL] = "still",
>> > +	[IIO_MOD_PED_STEPS] = "steps",
>> >  };
>> >
>> >  /* relies on pairs of these shared then separate */
>> > diff --git a/include/linux/iio/types.h b/include/linux/iio/types.h
>> > index 003638d..ae51780 100644
>> > --- a/include/linux/iio/types.h
>> > +++ b/include/linux/iio/types.h
>> > @@ -65,6 +65,7 @@ enum iio_modifier {
>> >  	IIO_MOD_JOGGING,
>> >  	IIO_MOD_WALKING,
>> >  	IIO_MOD_STILL,
>> > +	IIO_MOD_PED_STEPS,
>> >  };
>> >
>> >  enum iio_event_type {
>> >

-- 
Sent from my Android phone with K-9 Mail. Please excuse my brevity.
