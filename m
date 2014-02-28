Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaB1Uc0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 15:32:26 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:48457 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907AbaB1UcN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 15:32:13 -0500
MIME-Version: 1.0
In-Reply-To: <20140228020536.GB5427@earth.universe>
References: <1393375569-21751-1-git-send-email-sre@debian.org>
	<1393375569-21751-2-git-send-email-sre@debian.org>
	<CAAfyv37B=xn3AktnUxPDpuey+5S73vW0PJnuUZtorP4rajPKiw@mail.gmail.com>
	<20140226215452.GA11468@earth.universe>
	<CAAfyv340pA2ihUAoFytBgevLtedvtj5Z0aw_=G9Rbx5occtyqw@mail.gmail.com>
	<20140228020536.GB5427@earth.universe>
Date: Fri, 28 Feb 2014 21:32:12 +0100
Message-ID: <CAAfyv36jJoMxZQ5e43pEC2rzNBHHW9Jt_4dg5O-fS8e+Aim7jA@mail.gmail.com>
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

On Fri, Feb 28, 2014 at 3:05 AM, Sebastian Reichel <sre@debian.org> wrote:
> On Thu, Feb 27, 2014 at 10:34:35PM +0100, Belisko Marek wrote:
>> Well I've tried and it's worse :). I got during booting:
>> [    2.218383] ERROR: could not get IIO channel /battery:temp(0)
>> [    2.224639] platform battery.4: Driver twl4030_madc_battery
>> requests probe deferral
>> Not sure if it's just error or warning but temp is always reported as
>> 0 (and also other values in sysfs).
>
> This is an error, which basically means, that twl4030-madc has not
> yet been loaded. Do you get proper values when you use the old madc
> API with the patchset applied?
It works without converting to iio consumer (at least I get some
reasonable values).
With conversion it fails with above error. I recheck (add printk to
iio twl4030-madc) that
madc driver is loaded. Could this be that twl4030_madc_battery is
loaded earlier then
twl4030_madc and than it fails to get iio channels?
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
