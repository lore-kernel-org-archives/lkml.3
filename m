Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753823AbaJGNy1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 09:54:27 -0400
Received: from mga01.intel.com ([192.55.52.88]:63078 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751266AbaJGNyZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 09:54:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,670,1406617200"; 
   d="scan'208";a="482530934"
From: "Tirdea, Irina" <irina.tirdea@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
CC: "Baluta, Daniel" <daniel.baluta@intel.com>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [RFC PATCH 4/8] iio: core: Introduce pedometer STEP counter
 modifier
Thread-Topic: [RFC PATCH 4/8] iio: core: Introduce pedometer STEP counter
 modifier
Thread-Index: AQHP39IqO8PzZJcz2UyGrX1QEK4nhZwjD6NAgAAl4YCAAXWuoA==
Date: Tue, 7 Oct 2014 13:54:21 +0000
Deferred-Delivery: Tue, 7 Oct 2014 13:54:00 +0000
Message-ID: <1F3AC3675D538145B1661F571FE1805F199ADF59@IRSMSX105.ger.corp.intel.com>
References: <1412257439-15683-1-git-send-email-daniel.baluta@intel.com>
 <1412257439-15683-5-git-send-email-daniel.baluta@intel.com>
 <542FEDB7.3050302@kernel.org>
 <1F3AC3675D538145B1661F571FE1805F199AD91D@IRSMSX105.ger.corp.intel.com>
 <888C517D-6823-4FB5-870E-484DADAF5230@kernel.org>
In-Reply-To: <888C517D-6823-4FB5-870E-484DADAF5230@kernel.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [163.33.239.181]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id s97DsWSI016889



> -----Original Message-----
> From: linux-iio-owner@vger.kernel.org [mailto:linux-iio-owner@vger.kernel.org] On Behalf Of Jonathan Cameron
> On October 6, 2014 2:50:13 PM GMT+01:00, "Tirdea, Irina" <irina.tirdea@intel.com> wrote:
> >> From: Jonathan Cameron [mailto:jic23@kernel.org]
> >> On 02/10/14 14:43, Daniel Baluta wrote:
> >> > From: Irina Tirdea <irina.tirdea@intel.com>
> >> >
> >> > One of the functionalities of a pedometer is a step counter.
> >> > The step counter needs to be enabled and then it will count the
> >steps
> >> > in its hardware register. Whenever the applications need to check
> >> > the step count, they will read the step counter register.
> >> >
> >> > To support this functionality we need a steps attribute that
> >> > will export the number of steps.
> >> >
> >> I'm not keen on multiplexing different types of data onto a single
> >activity type.
> >> Steps is well enough defined on it's own to have it's own channel
> >type.
> >>
> >> in_steps_input would be fine by me.  I suppose steps might mean
> >something else
> >> though...
> >>
> >
> >Hi Jonathan,
> >
> >Thanks for the review.
> >
> >Moving the pedometer part to a new type sounds good to me.
> >However, I would prefer to add a new type called pedometer and keep
> >steps as a modifier, generating names like in_ped_steps_input for the
> >attribute and in_ped_steps_instance_en for the event.
> >The reason for this is that for supporting Freescale's MMA9553L we will
> >need additional attributes (distance, speed, calories, height, weight)
> >that we can add as modifiers to this pedometer type. To keep things
> >simple, I did not add these additional attributes to the RFC series,
> >but I could do that if you think it would be useful. For this device,
> >the motion events (walking, running, jogging, still) also depend on the
> >height attribute being set, but we intend to deal with this dependency
> >in the driver (using the pedometer's height attribute).
> >
> >What do you think?
> I think I would rather each of these was included as a type rather than a modifier.
> There are lots of other ways to measure speed for starters and often user space
> won't care where it comes from...
> 
> In_speed_raw etc...
> 
> Trick where possible is to think about what is measured rather than how. Tends to give
>  more consistent interfaces.

That makes sense. Will do the changes and also add one of these other types in v2.

Thanks,
Irina

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
