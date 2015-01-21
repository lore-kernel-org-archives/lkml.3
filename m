Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751972AbbAULCY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 06:02:24 -0500
Received: from mail1.bemta5.messagelabs.com ([195.245.231.144]:26773 "EHLO
	mail1.bemta5.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750754AbbAULCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 06:02:13 -0500
X-Env-Sender: Adam.Thomson.Opensource@diasemi.com
X-Msg-Ref: server-12.tower-179.messagelabs.com!1421838128!38299971!1
X-Originating-IP: [94.185.165.51]
X-StarScan-Received: 
X-StarScan-Version: 6.12.5; banners=-,-,-
X-VirusChecked: Checked
From: "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>
To: Jonathan Cameron <jic23@kernel.org>,
        "Opensource [Adam Thomson]" <Adam.Thomson.Opensource@diasemi.com>,
        Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Hartmut Knaack <knaack.h@gmx.de>,
        "linux-iio@vger.kernel.org" <linux-iio@vger.kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        "David Woodhouse" <dwmw2@infradead.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        "Grant Likely" <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Joe Perches" <joe@perches.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Support Opensource" <Support.Opensource@diasemi.com>
Subject: RE: [PATCH v5 3/7] iio: Add support for DA9150 GPADC
Thread-Topic: [PATCH v5 3/7] iio: Add support for DA9150 GPADC
Thread-Index: AQHQHgeDACkwhZZVu0GGIrbpGz25MpywSfUAgASgJaCABSDGgIAFk67wgAoKjACAAO38sA==
Date: Wed, 21 Jan 2015 11:02:07 +0000
Message-ID: <2E89032DDAA8B9408CB92943514A0337AB528C82@SW-EX-MBX01.diasemi.com>
References: <cover.1419264383.git.Adam.Thomson.Opensource@diasemi.com>
 <58b7b001b38662c36595412f96c7d2eb5c3adcad.1419264383.git.Adam.Thomson.Opensource@diasemi.com>
 <54A976D2.9040104@kernel.org>
 <2E89032DDAA8B9408CB92943514A0337AB526A19@SW-EX-MBX01.diasemi.com>
 <54B1A563.5080404@kernel.org>
 <2E89032DDAA8B9408CB92943514A0337AB527B9D@SW-EX-MBX01.diasemi.com>
 <54BEBF58.30308@kernel.org>
In-Reply-To: <54BEBF58.30308@kernel.org>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.20.26.15]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id t0LB2SNd019163

On January 20, 2015 20:49, Jonathan Cameron wrote:

> >>>>> +#define DA9150_GPADC_CHANNEL_PROCESSED(_id, _hw_id, _type,
> >> _ext_name)
> >>>> 	\
> >>>>> +	DA9150_GPADC_CHANNEL(_id, _hw_id, _type,			\
> >>>>> +			     BIT(IIO_CHAN_INFO_PROCESSED), _ext_name)
> >>>>> +
> >>>>> +/* Supported channels */
> >>>>> +static const struct iio_chan_spec da9150_gpadc_channels[] = {
> >>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOA, GPIOA_6V, IIO_VOLTAGE,
> >>>> "GPIOA"),
> >>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOB, GPIOB_6V, IIO_VOLTAGE,
> >>>> "GPIOB"),
> >>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOC, GPIOC_6V, IIO_VOLTAGE,
> >>>> "GPIOC"),
> >>>>> +	DA9150_GPADC_CHANNEL_PROCESSED(GPIOD, GPIOD_6V, IIO_VOLTAGE,
> >>>> "GPIOD"),
> >>>> I'm not sure some of these really deserve extended names.  Those are usually
> >>>> reserved for naming strange internal adc channels etc.  These first 4 are
> >>>> presumably just for input pins?  Those should just be channels 0..3
> >>>> On another note, unless you want really weird sysfs attribute names, the
> >>>> extended names want to be lowercase.
> >>>>
> >>>
> >>> I'd prefer to keep the names because the input pins are muxed with GPIOs of the
> >>> chip, so thought it sensible to show that this is the case. Am happy to change
> >>> to lower-case to follow convention.
> >> Hmm.  It's a bit of an oddity as the point of the naming
> >> is about the uses, not which pins they are on.  If we exposed the
> >> 'datasheet_name' parameter directly rather than just using it internally
> >> I'd suggest relying on that - but clearly you want it to be apparent
> >> in the interface.  Whether that is useful is the question I'd raise
> >> here (and is the reason datasheet_name is not exposed.
> >>
> >> The obvious question is does userspace care?  Answer is probably not.
> >>
> >> It cares what is being measured but this is about what pins it is
> >> on and doesn't provide any information on what is connected to them.
> >>
> >
> > Surely it helps when using sysfs to access whatever is connected to one of
> > those pins if we label the pin with something meaningful? If say you have a
> > device connected to GPIC of the charger IC, it's easier to work out which ADC
> > channel you need to access through sysfs if the naming is as I have now, rather
> > than some arbitrary number which doesn't necessarily tally to the channel in the
> > datasheet. You'd then need to look at the code and work out which channel
> number
> > GPIOC actually was. Or am I just missing something here? :)
> Not really for the vast majority of users.  They tend not to have a detailed
> board layout in front of them.  It's more interesting if you know 'what' they
> are measuring (hence we do use these names when that is true - such as
> internal voltage measurements).
> 
> The numbers almost never tally with the datasheet, but then datasheet numbering
> has a habit of being inconsistent as well!

Can't say I agree that this won't be useful/informative to many users, but don't
want to make this a sticking point so will update.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
