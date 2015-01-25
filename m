Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbbAYKuJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jan 2015 05:50:09 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:44311 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751535AbbAYKuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jan 2015 05:50:04 -0500
MIME-Version: 1.0
In-Reply-To: <54C4C510.5090306@kernel.org>
References: <1421921412-7710-1-git-send-email-daniel.baluta@intel.com>
	<54C4C510.5090306@kernel.org>
Date: Sun, 25 Jan 2015 12:50:02 +0200
X-Google-Sender-Auth: i-QFMBDUW9uIObxkopHIBwtGeV4
Message-ID: <CAEnQRZAhTQEGiSeAOahG4A_iZhPgMYnoHwLjDeEWKarwVJO3qg@mail.gmail.com>
Subject: Re: [PATCH] iio: light: Add support for Capella CM3323 color/light sensor
From: Daniel Baluta <daniel.baluta@intel.com>
To: Jonathan Cameron <jic23@kernel.org>
Cc: Daniel Baluta <daniel.baluta@intel.com>,
        Kevin Tsai <ktsai@capellamicro.com>, Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 25, 2015 at 12:27 PM, Jonathan Cameron <jic23@kernel.org> wrote:
> On 22/01/15 10:10, Daniel Baluta wrote:
>> Minimal implementation providing raw light intensity and illuminance
>> readings. For illuminance user can compute lux values using raw readings
>> and scale.
>>
>> This driver also supports CM3323E sensor chip.
>>
>> Cc: Kevin Tsai <ktsai@capellamicro.com>
>> Signed-off-by: Daniel Baluta <daniel.baluta@intel.com>
>
> Hi Daniel,
>
> My only real question on this one is whether using the 'green' channel
> and pretending it is a measure of illuminance is a good idea or whether
> we are better leaving that decision to userspace...
>
> I'm guessing the reason it is green rather than clear is that
> the clear is letting infrared through and we don't have an additional
> infrared sensor available to allow that component to be removed?

Hi Jonathan,

<snip>
>> +#define CM3323_COLOR_CHANNEL(_color, _addr) {\
>> +     .type = IIO_INTENSITY, \
>> +     .modified = 1, \
>> +     .info_mask_separate = BIT(IIO_CHAN_INFO_RAW), \
>> +     .info_mask_shared_by_all = BIT(IIO_CHAN_INFO_INT_TIME), \
>> +     .channel2 = IIO_MOD_LIGHT_##_color, \
>> +     .address = _addr, \
>> +}
>> +
>> +/*
>> + * CM3323's GREEN channel is used for reading illuminance
> That's impressively random and unlikely to be anywhere near correct
> pretty much all the time!
>
> I'd personally prefer just not providing an illuminance channel
> and leaving it up to userspace to make the decision on whether the
> green channel is good enough...

Datasheet says that the GREEN channel should be used
for getting illuminance readings. I'm not sure if this is
totally random.

I understand your worries, perhaps Kevin could 'enlighten' us here.

I would  prefer to have the illuminance channel exported from
IIO because there are already userspace applications/frameworks
 written and tested for ALS that use IIO illuminance channel.
We want to use this driver without modifying user space.

Of course, one option for the moment would be to only export
the INTENSITY channels as per your recommendation and
to decide later what to do for the LIGHT channel.


Thanks for review!

Daniel.
