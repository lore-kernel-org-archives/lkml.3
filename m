Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498AbaHUEal (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 00:30:41 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:38239 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752160AbaHUEaj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 00:30:39 -0400
MIME-Version: 1.0
In-Reply-To: <53F1E1EA.8060708@gmail.com>
References: <1408026327-31437-1-git-send-email-b.zolnierkie@samsung.com>
	<1408026327-31437-4-git-send-email-b.zolnierkie@samsung.com>
	<34FCC3B2EE8F481198CEF3037F168FB3@sisodomain.com>
	<3463371.y41zGdSnsX@amdc1032>
	<53F1E1EA.8060708@gmail.com>
Date: Thu, 21 Aug 2014 10:00:38 +0530
X-Google-Sender-Auth: 2r1SvH6Ius6Ia45QuJ1HfRmufj0
Message-ID: <CAFp+6iGtMUEncFwJ=B_p=q8Bs_O9EMyjsL+ZP9PveO=VMrLmpA@mail.gmail.com>
Subject: Re: [PATCH 3/5] usb: phy: samsung: remove old USB 2.0 PHY driver
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Kamil Debski <k.debski@samsung.com>, Mark Brown <broonie@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz and Bartlomiej,


On Mon, Aug 18, 2014 at 4:52 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> On 18.08.2014 13:02, Bartlomiej Zolnierkiewicz wrote:
>> On Thursday, August 14, 2014 08:07:40 PM Vivek Gautam wrote:
>>> On Thursday, August 14, 2014 7:55 PM, Bartlomiej Zolnierkiewicz
>>> <b.zolnierkie@samsung.com> wrote
>>
>>> There's one thing that I would want to comment here, since we don't have any
>>> new usb-phy driver for S3C64XX,
>>> so we can't simply remove this entire driver.
>>> I have posted my patch-series [1], which does cleanup while keeping the
>>> support for S3C64XX.
>>
>> AFAIK S3C64XX code from drivers/usb/phy/phy-samsung-usb2.c has
>> never been used as this platform still uses its own code from
>> arch/arm/mach-s3c64xx/setup-usb-phy.c (there are no users in
>> the kernel tree of either s3c64xx-usb2phy platform device or
>> "samsung,s3c64xx-usb2phy" DT compatible) .  Therefore I think
>> that the entire drivers/usb/phy/phy-samsung-usb2.c driver
>> should be removed (somebody with the hardware can as well add
>> S3C64XX support to the new drivers/phy/phy-samsung-usb2.c
>> driver and port the platform to use it).
>>
>
> I agree with removal of this driver. As Bart said, it is not used for
> S3C64xx at all. The platform was supposed to be moved to this driver,
> but that never happened. In fact, I already have a patch adding support
> for S3C64xx to the new driver.

Cool then, lets remove this driver completely and use the new generic
PHY based driver
once that comes (from Tomasz).

I shall drop the patches for cleaning up the usb-phy drivers from my series.


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
