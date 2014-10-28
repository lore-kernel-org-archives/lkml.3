Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754659AbaJ1KWU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 06:22:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:53008 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaJ1KWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 06:22:18 -0400
MIME-Version: 1.0
In-Reply-To: <544BF76E.8010500@kernel.org>
References: <1412858385-11954-1-git-send-email-daniel.baluta@intel.com>
	<1412858385-11954-5-git-send-email-daniel.baluta@intel.com>
	<544AD34A.9070005@gmx.de>
	<544BF76E.8010500@kernel.org>
Date: Tue, 28 Oct 2014 12:22:16 +0200
X-Google-Sender-Auth: szimQpSbs87fROV_vCfmuyRw9ls
Message-ID: <CAEnQRZBUi=m55dP5=B8ahHFgb6o2JA2cWTh0aZf8RNtWid1yEw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/7] iio: core: Introduce STEPS channel type,
 ENABLE mask and INSTANCE event
From: Daniel Baluta <daniel.baluta@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>, Daniel Baluta <daniel.baluta@intel.com>,
        irina.tirdea@intel.com, linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 25, 2014 at 10:18 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 24/10/14 23:31, Hartmut Knaack wrote:
>> Daniel Baluta schrieb am 09.10.2014 14:39:
>>> From: Irina Tirdea <irina.tirdea@intel.com>
>>>
>>> These changes are needed to support the functionality of a pedometer.
>>> A pedometer has two basic functionalities: step counter and step detector.
>>>
>>> The step counter needs to be enabled and then it will count the steps
>>> in its hardware register. Whenever the application needs to check
>>> the step count, it will read the step counter register. To support the
>>> step counter a new channel type STEPS is added. Since the pedometer needs
>>> to be enabled first so that the hardware can count and store the steps,
>>> we need a specific ENABLE channel info mask.
>>>
>>> The step detector will generate an interrupt each time a step is detected.
>>> To support this functionality we add a new event type INSTANCE.
>>>
>> Hi,
>> I was wondering, if it would be better to name this channel somehow more generic. What you are actually counting are some pulses, and only the implementation of the hardware leads to the interpretation of these pulses as for example steps.
>> Other devices for this category would be pulse counters - either stand alone, or as part of SoCs. Some use cases I could think of are: liquid/gas flow measurements, engine rotation/RPM counts, object counts, ...
>> Any opinions?
>
> I agree there might be potential here for a broader interface...    RPM however
> would be a rotational speed measurement and hence in radians / second or
> radians if just a count of pulses off an encoder.
>
> We have just recently had a human pulse counter as well which is another count.
>
> The question to my mind is do we gain anything by making it more generic?
> Does it help userspace?  Chances of having many applications that don't care
> about the difference between steps and other pulse counts is probably low
> so right now I'm (slightly) falling on the side of have these more specific
> counts.
>
> So what does everyone else think?

I think making this more generic might confuse the users. Having this
more specific makes the interface very clear about who should use it.

Daniel.
