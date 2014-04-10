Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965622AbaDJJfD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 05:35:03 -0400
Received: from gloria.sntech.de ([95.129.55.99]:40074 "EHLO gloria.sntech.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935066AbaDJJet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 05:34:49 -0400
From: Heiko =?ISO-8859-1?Q?St=FCbner?= <heiko.stuebner@bq.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Matthias Brugger <matthias.bgg@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>, Andrew Lunn <andrew@lunn.ch>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Jason Cooper <jason@lakedaemon.net>, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Herring <robh+dt@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Silvio F <silvio.fricke@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, Jonathan Cameron <jic23@kernel.org>
Subject: Re: [PATCH 3/4] arm: add basic support for Mediatek MT6589 boards
Date: Thu, 10 Apr 2014 11:34:47 +0200
Message-ID: <3428574.kpvz0qlT1a@diego>
User-Agent: KMail/4.11.5 (Linux/3.13-1-amd64; KDE/4.11.3; x86_64; ; )
In-Reply-To: <53465A4B.4040906@free-electrons.com>
References: <1397072736-10793-1-git-send-email-matthias.bgg@gmail.com> <CABuKBeKnEw38sQYwrkheoWetZZcPTJhKRsBK4a62FS6-6dRFTA@mail.gmail.com> <53465A4B.4040906@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gregory,

Am Donnerstag, 10. April 2014, 08:46:03 schrieb Gregory CLEMENT:
> On 10/04/2014 08:29, Matthias Brugger wrote:
> > 2014-04-09 22:26 GMT+02:00 Gregory CLEMENT <gregory.clement@free-
electrons.com>:
> >> Hi Matthias,
> >> 
> >> On 09/04/2014 19:45, Matthias Brugger wrote:
> >>> diff --git a/arch/arm/boot/dts/mtk6589.dtsi
> >>> b/arch/arm/boot/dts/mtk6589.dtsi new file mode 100644
> >>> index 0000000..6dbb74f
> >>> --- /dev/null
> >>> +++ b/arch/arm/boot/dts/mtk6589.dtsi
> >>> @@ -0,0 +1,105 @@
> >>> +/*
> >>> + * Copyright (c) 2014 MundoReader S.L.
> >>> + * Author: Matthias Brugger <matthias.bgg@gmail.com>
> >>> + *
> >>> + * This program is free software; you can redistribute it and/or modify
> >>> + * it under the terms of the GNU General Public License as published by
> >>> + * the Free Software Foundation; either version 2 of the License, or
> >>> + * (at your option) any later version.
> >>> + *
> >>> + * This program is distributed in the hope that it will be useful,
> >>> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> >>> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> >>> + * GNU General Public License for more details.
> >>> + */
> >>> +
> >>> +#include <dt-bindings/interrupt-controller/irq.h>
> >>> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> >>> +#include "skeleton.dtsi"
> >>> +
> >>> +/ {
> >>> +     compatible = "mediatek,mt6589";
> >>> +     interrupt-parent = <&gic>;
> >>> +
> >>> +     cpus {
> >>> +             #address-cells = <1>;
> >>> +             #size-cells = <0>;
> >>> +
> >>> +             cpu@0 {
> >>> +                     device_type = "cpu";
> >>> +                     compatible = "arm,cortex-a7";
> >>> +                     next-level-cache = <&L2>;
> >>> +                     reg = <0x0>;
> >>> +             };
> >>> +             cpu@1 {
> >>> +                     device_type = "cpu";
> >>> +                     compatible = "arm,cortex-a7";
> >>> +                     next-level-cache = <&L2>;
> >>> +                     reg = <0x1>;
> >>> +             };
> >>> +             cpu@2 {
> >>> +                     device_type = "cpu";
> >>> +                     compatible = "arm,cortex-a7";
> >>> +                     next-level-cache = <&L2>;
> >>> +                     reg = <0x2>;
> >>> +             };
> >>> +             cpu@3 {
> >>> +                     device_type = "cpu";
> >>> +                     compatible = "arm,cortex-a7";
> >>> +                     next-level-cache = <&L2>;
> >>> +                     reg = <0x3>;
> >>> +             };
> >>> +
> >>> +     };
> >>> +
> >>> +     clocks {
> >>> +             #address-cells = <1>;
> >>> +             #size-cells = <1>;
> >>> +             ranges;
> >>> +
> >>> +             system_clk: system_clk {
> >>> +                     compatible = "fixed-clock";
> >>> +                     clock-frequency = <13000000>;
> >>> +                     #clock-cells = <0>;
> >>> +                     clock-output-names = "system_clk";
> >>> +             };
> >> 
> >> Is it really a fixed clock without any parent, or do you
> >> declare it as a fixed clock because you don't have any clock
> >> common framework support yet?
> > 
> > I don't have any common clock framework support yet.
> 
> So maybe you should provide one (even a very simple one).
> 
> Pretending a clock is a fixed clock and ignoring its parents
> will be problematic when you will add the common clock framework
> support because the device tree is supposed to be stable and you won't
> be able to change it then.

personally I think the danger of introducing unsuitable bindings/precedents 
for a clock controller before it is fully understood is higher.

I'd just rename the clock above to something like dummy130m like sunxi also 
does for example, to reflect its unfinished state and when the clock controller 
is present later on change the supplying clock of the timer.

Or maybe I'm overlooking something here :-)


Heiko
