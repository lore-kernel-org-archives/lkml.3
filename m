Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754370AbaIDQ7L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 12:59:11 -0400
Received: from mail-oi0-f41.google.com ([209.85.218.41]:65011 "EHLO
	mail-oi0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbaIDQ7K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 12:59:10 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Sep 2014 12:59:09 EDT
MIME-Version: 1.0
In-Reply-To: <1450179.xJuMFg9Vvn@diego>
References: <1409254565-10677-1-git-send-email-dianders@chromium.org>
	<53FF9E93.3040601@ti.com>
	<CAD=FV=Vcj+tAno92c38Prviyi-v2CmuGSzak1ppETL033KAF4w@mail.gmail.com>
	<1450179.xJuMFg9Vvn@diego>
Date: Thu, 4 Sep 2014 18:51:47 +0200
Message-ID: <CACRpkda-XS0XLSkAZ-16=JvD8FbRJNuN4UVL4dMyV71bfU5T2A@mail.gmail.com>
Subject: Re: [PATCH 0/2] IO voltage domain support for rk3188 and rk3288
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kevin Hilman <khilman@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>
Cc: Doug Anderson <dianders@chromium.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Addy Ke <addy.ke@rock-chips.com>,
        Sonny Rao <sonnyrao@chromium.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Andy Gross <agross@codeaurora.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sandeep Nair <sandeep_n@ti.com>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Thierry Reding <treding@nvidia.com>, Nishanth Menon <nm@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 1:27 PM, Heiko Stübner <heiko@sntech.de> wrote:
> Am Freitag, 29. August 2014, 21:51:46 schrieb Doug Anderson:
>> On Thu, Aug 28, 2014 at 2:26 PM, Santosh Shilimkar
>>
>> <santosh.shilimkar@ti.com> wrote:
>> > On Thursday 28 August 2014 03:36 PM, Doug Anderson wrote:
>> >> These two patches add support for automatically configuring the IO
>> >> voltage domains on rk3188 and rk3288 SoCs.  The first patch adds some
>> >> new notification types to the regulator code.  It's used by the second
>> >> patch which actually implements the IO voltage domain driver.
>> >>
>> >> These two patches were co-developed by Heiko Stübner and Doug Anderson
>> >> (proof of concept patches were written by Heiko).  They were tested in
>> >> a private branch on an rk3288 board using rk808 instead of mainline
>> >> since rk808 support isn't finalized in mainline yet.
>> >>
>> >> (sorry if you got this series twice; my mailer seems unhappy with me)
>> >>
>> >> Heiko Stübner (2):
>> >>   regulator: core: Add REGULATOR_EVENT_PRE_VOLTAGE_CHANGE (and ABORT)
>> >>   soc/rockchip: io-domain: add driver handling io domains
>> >
>> > Sorry to shot down but your IO domains are nothing but voltage domains
>> > and you should really build something in the drivers/power/*
>>
>> If everyone agrees that this belongs in drivers/power that's totally
>> OK.  Neither Heiko nor I was confident that it should be in
>> drivers/soc.  I had even though that the code wouldn't be totally out
>> of place in the Rockchip pinctrl driver (adding Linus W since I think
>> some SoCs did add code to handle 3.3V vs. 1.8V in pinctrl).
>
> a bit of context for Linus ...
>
> This is essentially the continuation of  the thread "io-domain voltages as
> regulators?" from the beginning of august. After more discussions we found out
> that the io voltage selection I asked about is not an independent supply, but
> instead has to reflect the voltage of the real supplying regulator.
>
> And setting the io-voltage setting to 1.8V while the regulator is supplying
> 3.3V for example may actually damage the chip.
>
>
> So in our current approach here, we added a driver that tracks voltage changes
> of the supplying regulator via a notifier and sets the register bits
> accordingly.

I feel I'm not smart enough for this. You need the PM people to look
at this stuff, like Rafael Wysocki, Kevin Hilman and Ulf Hansson.

Since it is also MMC/SD UHS-related, Ulf should know better than
most what is needed, plus he's working on generic power domains
right now.

Yours,
Linus Walleij
