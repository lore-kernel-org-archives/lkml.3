Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab3FJRvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 13:51:46 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:34027 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754376Ab3FJRvo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 13:51:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130610164905.GJ1403@sirena.org.uk>
References: <1369246717-4167-1-git-send-email-nm@ti.com>
	<1369246717-4167-2-git-send-email-nm@ti.com>
	<20130610103131.GR31367@sirena.org.uk>
	<CAGo_u6qTiPpd0DDe3jnPh_UxTwox22azhcMGy=fftL8H+DGeyw@mail.gmail.com>
	<20130610164905.GJ1403@sirena.org.uk>
Date: Mon, 10 Jun 2013 12:51:42 -0500
X-Google-Sender-Auth: uzwdj796MwP61SoK7bMmSnBzbEo
Message-ID: <CAGo_u6ov=yaCwt8apbvW57ErAvhgUBHHw9gwADBC1fJUrfucUQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] regulator: Introduce OMAP regulator to control
 PMIC over VC/VP
From: Nishanth Menon <nm@ti.com>
To: Mark Brown <broonie@kernel.org>
Cc: Paul Walmsley <paul@pwsan.com>, Liam Girdwood <lgirdwood@gmail.com>,
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

On Mon, Jun 10, 2013 at 11:49 AM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Jun 10, 2013 at 11:16:59AM -0500, Nishanth Menon wrote:
>> On Mon, Jun 10, 2013 at 5:31 AM, Mark Brown <broonie@kernel.org> wrote:
>> > On Wed, May 22, 2013 at 01:18:34PM -0500, Nishanth Menon wrote:
>
>> > So, the biggest problem here has been patch 4 (having to have a hack to
>> > deploy this stuff is a bit worrying) plus the general not having a real
>> > driver thing.
>
>> Patch #4 in this series was a hack as it was not properly split up and
>> organized as a proper DTS series -it was meant as a proof of concept -
>> not entirely meant to indicate the remaining 1-3 patches were hacks
>> :).
>
> The way it reads is that you're building up to a hack - if what you've
> done isn't enabling a sensible solution there might be a problem with
> the earlier steps.

Understood, I should have taken extra steps to split up the patch into
it's logical series, but wanted to get a quick feel from community
about the approach before spending time on it. I apologize for the
confusion caused.

>
>> I think you mean http://marc.info/?t=137059249100003&r=1&w=2 series. I
>> will dig into it. if it is possible for Tegra and OMAP to use the same
>> framework and strategy to deal with these kind of h/w blocks, all the
>> more better.
>
> Not just better, if each system doing this sort of thing needs to
> reinvent the wheel something is going wrong.
Fair enough, I did spend a short while digging through the discussion
in the series, I need to find Tegra TRM to see if there is commonolity
between OMAP and what Tegra does at hardware level.
a) Tegra seems to use Lookup Table for sending predefinied voltage
values to PMIC. OMAP has no concept of lookup table.
b) Tegra and OMAP h/w blocks seem to use I2C - that is good.
c) How about the i2c slave and register addresses, slew rates, start,
end voltages, max voltages that SoC can support etc, I am yet to
understand those.
d) OMAP has 3 modules - AVS (SmartReflex), Voltage Processor(VP),
Voltage Controller(VC) - I am not yet sure about the Tegra hardware
blocks involved.

maybe Paul could comment as well, I suppose if we could take a common
approach between Tegra and OMAP.

Regards,
Nishanth Menon
