Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759204AbaJ1HZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:25:59 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:41519 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759179AbaJ1HZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 03:25:56 -0400
MIME-Version: 1.0
In-Reply-To: <20141027175725.GB18557@sirena.org.uk>
References: <1414427215-14380-1-git-send-email-romain.perier@gmail.com>
	<1414427215-14380-2-git-send-email-romain.perier@gmail.com>
	<20141027163918.GB14253@saruman>
	<20141027172636.GZ18557@sirena.org.uk>
	<20141027173025.GA16005@saruman>
	<20141027175725.GB18557@sirena.org.uk>
Date: Tue, 28 Oct 2014 08:25:55 +0100
Message-ID: <CABgxDo+goYskzGB5uCTkteOs5=6+vRbYCABMh8D_3qZxQC0thA@mail.gmail.com>
Subject: Re: [PATCH v1 02/10] dt-bindings: Document the standard property "system-power-controller"
From: Romain Perier <romain.perier@gmail.com>
To: Mark Brown <broonie@kernel.org>
Cc: Felipe Balbi <balbi@ti.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        devicetree <devicetree@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>, robh <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Johan Hovold <johan@kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, "pawel.moll" <pawel.moll@arm.com>,
        "ijc+devicetree" <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If this is possible, that's probably better to drop all these patches
(including poweroff-source) from "next", in this way it will be
possible to re-do things properly from scratch (with the new name).

If you have a look at linux-next the property "poweroff-source" is
already used by tps910 AND act8865, I don't like that (it is not used
yet by dts files). I mean, I don't really want to support
"vendor,system-power-controller", "system-power-controller" and
"poweroff-source" from "of_has_system_power_source" and do a lot of
unclean commits in order to don't break compatibility. Just keep
things simple.

What do you think ?


2014-10-27 18:57 GMT+01:00 Mark Brown <broonie@kernel.org>:
> On Mon, Oct 27, 2014 at 12:30:25PM -0500, Felipe Balbi wrote:
>> On Mon, Oct 27, 2014 at 05:26:36PM +0000, Mark Brown wrote:
>
>> > Given that poweroff-source hasn't made it into a released kernel yet we
>> > can probably just kill it off completely can't we?
>
>> please do, then we will never have that commit in Linus' tree to give us
>> nightmares.
>
> Well, the commit isn't a particularly big deal (and got cross-merged
> into another tree already) - if it's convenient to rebase it out we
> probably should but it's also not the end of the world either so long as
> it doesn't appear in a release.  Worst case people adopt it based on the
> list discussions and we check for two properties which also isn't that
> bad.
