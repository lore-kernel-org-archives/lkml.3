Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282AbaB0Vej (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 16:34:39 -0500
Received: from mail-ob0-f172.google.com ([209.85.214.172]:55442 "EHLO
	mail-ob0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaB0Veg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 16:34:36 -0500
MIME-Version: 1.0
In-Reply-To: <20140226215452.GA11468@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
	<1393375569-21751-2-git-send-email-sre@debian.org>
	<CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
	<20140226215452.GA11468@earth.universe>
Date: Thu, 27 Feb 2014 22:34:35 +0100
Message-ID: <CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
Subject: Re: [PATCHv1 1/2] rx51_battery: convert to iio consumer
From: Belisko Marek <marek.belisko@gmail.com>
To: Sebastian Reichel <sre@debian.org>
Cc: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Jonathan Cameron <jic23@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-iio@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On Wed, Feb 26, 2014 at 10:54 PM, Sebastian Reichel <sre@debian.org> wrote:
> Hi,
>
> On Wed, Feb 26, 2014 at 10:43:40PM +0100, Belisko Marek wrote:
>> [...]
>> > +       int val, err;
>> > +       err = iio_read_channel_average_raw(channel, &val);
>> Where this function comes from? I cannot find it in current linux-next
>> (only iio_read_channel_raw()). Am I missing some patches? Thx.
>
> Ah right. I planned to send a patch adding this function together
> with the rx51-battery patchset, but it seems I forgot to include it.
>
> Sorry for the inconvenience. I will send it out as a separate patch
> now.
>
>> BTW when I convert to iio consumer and use DT some of values work
>> but some of them just report 0 :( (I don't have latest twl4030-madc
>> iio patches).
>
> Can you retry with the twl4030-madc iio patch from today? The
> older patchsets, which do not contain the "tested on real hw"
> note are slightly broken.
Well I've tried and it's worse :). I got during booting:
[    2.218383] ERROR: could not get IIO channel /battery:temp(0)
[    2.224639] platform battery.4: Driver twl4030_madc_battery
requests probe deferral
Not sure if it's just error or warning but temp is always reported as
0 (and also other values in sysfs).

My patches ca be found here:
https://patchwork.kernel.org/patch/3735981/
https://patchwork.kernel.org/patch/3735961/
https://patchwork.kernel.org/patch/3735941/

>
> -- Sebastian

BR,

marek

-- 
as simple and primitive as possible
-------------------------------------------------
Marek Belisko - OPEN-NANDRA
Freelance Developer

Ruska Nova Ves 219 | Presov, 08005 Slovak Republic
Tel: +421 915 052 184
skype: marekwhite
twitter: #opennandra
web: http://open-nandra.com
