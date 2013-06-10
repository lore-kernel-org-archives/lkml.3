Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752587Ab3FJQRD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 12:17:03 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:44855 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab3FJQRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 12:17:00 -0400
MIME-Version: 1.0
In-Reply-To: <20130610103131.GR31367@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
	<1369246717-4167-2-git-send-email-nm@ti.com>
	<20130610103131.GR31367@sirena.org.uk>
Date: Mon, 10 Jun 2013 11:16:59 -0500
X-Google-Sender-Auth: bI-cgH0-F6r1fLLjTVaCPoaoIps
Message-ID: <CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>, Paul Walmsley <paul@pwsan.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>, devicetree-discuss@lists.ozlabs.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-doc@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        linux-omap <linux-omap@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Paul.

On Mon, Jun 10, 2013 at 5:31 AM, Mark Brown <broonie@kernel.org> wrote:
> On Wed, May 22, 2013 at 01:18:34PM -0500, Nishanth Menon wrote:
>
> So, the biggest problem here has been patch 4 (having to have a hack to
> deploy this stuff is a bit worrying) plus the general not having a real
> driver thing.
Patch #4 in this series was a hack as it was not properly split up and
organized as a proper DTS series -it was meant as a proof of concept -
not entirely meant to indicate the remaining 1-3 patches were hacks
:).

>
>> +- ti,i2c-slave-address - I2C slave address of the PMIC
>> +- ti,i2c-voltage-register - I2C register address where voltage commands are
>> +     to be set.
>> +- ti,i2c-command-register - I2C register address where commands are to be set
>> +     when OMAP enters low power state. This may be the same as
>> +     ti,i2c-voltage-register depending on the PMIC.
>> +- ti,slew-rate-microvolt - worst case slew rate of rise / fall for voltage
>> +     transition in microvolts per microseconds (uV/uS)
>> +- step-size-micro-volts - Step size in micovolts as to what one step in voltage
>> +     selector increment translates to. See example.
>> +- regulator-min-microvolt - Minimum voltage in microvolts which is supported by
>> +     the PMIC in ti,step-size-microvolt increments. See example.
>> +- regulator-max-microvolt - Maximum voltage in microvolts which is supported
>> +     by the PMIC in ti,step-size-microvolt increments. See example.
>
> The other thing is this whole business of encoding the properties of the
> PMIC in the DT like this.  Paul Walmsley has started doing some work for
> some similiar hardware where instead of doing this the regulator is in
> the DT as normal and then the driver for the offloaded voltage scaling
> gets the information about the register layout from the regulator
> driver.  This is a bit neater overall and would cope with determining
> which method to use at runtime.

I think you mean http://marc.info/?t=137059249100003&r=1&w=2 series. I
will dig into it. if it is possible for Tegra and OMAP to use the same
framework and strategy to deal with these kind of h/w blocks, all the
more better.

Regards,
Nishanth Menon
