Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbbA2PoX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 10:44:23 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54713 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbbA2PoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 10:44:21 -0500
MIME-Version: 1.0
In-Reply-To: <20150129142740.GH12209@pengutronix.de>
References: <1422022202-7526-1-git-send-email-s.hauer@pengutronix.de>
	<20150126114735.GA3178@pengutronix.de>
	<CABuKBe+x9o5OiysnMq-gvOBx3nKoaheL2efZGA6YQ7ZT5aqijw@mail.gmail.com>
	<20150129142740.GH12209@pengutronix.de>
Date: Thu, 29 Jan 2015 16:44:19 +0100
Message-ID: <CABuKBe+gCH9+qOAyu0NGknt83eLjMhe7+MeuEU0k9H=qoHV7oQ@mail.gmail.com>
Subject: Re: [PATCH v2] MediaTek PMIC support
From: Matthias Brugger <matthias.bgg@gmail.com>
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        Samuel Ortiz <sameo@linux.intel.com>,
        =?UTF-8?B?WUggQ2hlbiAo6Zmz5pix6LGqKQ==?= <yh.chen@mediatek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Henry Chen <henryc.chen@mediatek.com>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?WWluZ2pvZSBDaGVuICjpmbPoi7HmtLIp?= 
	<Yingjoe.Chen@mediatek.com>,
        Eddie Huang <eddie.huang@mediatek.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Liao <jamesjj.liao@mediatek.com>,
        Mike Turquette <mturquette@linaro.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2015-01-29 15:27 GMT+01:00 Sascha Hauer <s.hauer@pengutronix.de>:
> On Thu, Jan 29, 2015 at 01:39:42PM +0100, Matthias Brugger wrote:
>> Hi Sascha,
>>
>> 2015-01-26 12:47 GMT+01:00 Sascha Hauer <s.hauer@pengutronix.de>:
>> > Olof, Arnd,
>> >
>> > OK to put the driver into drivers/soc/mediatek? Can you take these
>> > patches?
>>
>> How does this patches fit together with the one James clock framework patches?
>> Both use the same compatible "mediatek,mt8135-infracfg" and
>> "mediatek,mt8135-pericfg".
>>
>> I had a look on other implementations and they attach the reset
>> controller to the clk driver, if they share the same hw block.
>> Might we run into problems if we implement the clocks in the mfd, as
>> we need the clocks early in boot (e.g. for the timer)?
>
> From my experience the clocks are needed by the timer before any driver
> initializes.
>
>>
>> In mt6589 pericfg apart from the clocks and reset controller provides
>> registers for AXI bus control and USB wakeup and USB clock selection.
>> The infracfg block provides top AXI bus fabric control signals and
>> remap registers for the modem.
>> Mike, Stephen, what do you think. Can we implement the clk in a mfd
>> driver? Or do you prefer to implement the whole block in the clk
>> driver?
>
> Currently the clk support uses regular CLK_OF_DECLARE which handles the
> clock part of pericfg/infracfg and then later a regular driver for
> pericfg/infracfg comes and handles the rest of the functionality. Since
> both use separate registers in the device register space it should work
> fine.

It should work until some driver start to use request and map, as you
provide the whole register space.
If you want to implement drivers for pericfg/infracfg like this, why
don't you implement the reset controller in drivers/reset?

Anyway I'm not really happy with the solution of having several device
drivers for the same dts compatible string.

>
> Sascha
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |



-- 
motzblog.wordpress.com
