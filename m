Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754201AbaE1HWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 03:22:46 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:51537 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751353AbaE1HWn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 03:22:43 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Kukjin Kim <kgene.kim@samsung.com>,
        "'Tarek Dakhran'" <t.dakhran@samsung.com>,
        linux-kernel@vger.kernel.org
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <01a201cf7a30$41ecca90$c5c65fb0$@samsung.com>
Cc: "'Rob Herring'" <robh+dt@kernel.org>, "'Pawel Moll'" <pawel.moll@arm.com>,
        "'Mark Rutland'" <mark.rutland@arm.com>,
        "'Ian Campbell'" <ijc+devicetree@hellion.org.uk>,
        "'Kumar Gala'" <galak@codeaurora.org>,
        "'Rob Landley'" <rob@landley.net>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Tomasz Figa'" <t.figa@samsung.com>,
        "'Vyacheslav Tyrtov'" <v.tyrtov@samsung.com>,
        "'Thomas Abraham'" <thomas.abraham@linaro.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Heiko Stuebner'" <heiko@sntech.de>,
        "'Romain Naour'" <romain.naour@openwide.fr>,
        "'Chander Kashyap'" <chander.kashyap@linaro.org>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org,
        "'Tarek Dakhran'" <t.dakhran@gmail.com>,
        "'Tarek Dakhran'" <t.dakhran@samsung.com>,
        "'Jonghwan Choi'" <jhbird.choi@samsung.com>
References: <1401074613-29227-1-git-send-email-t.dakhran@samsung.com>
 <1401074613-29227-3-git-send-email-t.dakhran@samsung.com>
 <20140528004116.7816.69646@quantum>
 <01a201cf7a30$41ecca90$c5c65fb0$@samsung.com>
Message-ID: <20140528072240.10062.16890@quantum>
User-Agent: alot/0.3.5
Subject: RE: [PATCH v11 2/3] clk: exynos5410: register clocks using common clock
 framework
Date: Wed, 28 May 2014 00:22:40 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kukjin Kim (2014-05-27 21:49:49)
> Mike Turquette wrote:
> > 
> > Quoting Tarek Dakhran (2014-05-25 20:23:32)
> > > The EXYNOS5410 clocks are statically listed and registered
> > > using the Samsung specific common clock helper functions.
> > >
> > > Signed-off-by: Tarek Dakhran <t.dakhran@samsung.com>
> > > Signed-off-by: Vyacheslav Tyrtov <v.tyrtov@samsung.com>
> > > ---
> > >  .../devicetree/bindings/clock/exynos5410-clock.txt |   45 +++++
> > >  drivers/clk/samsung/Makefile                       |    1 +
> > >  drivers/clk/samsung/clk-exynos5410.c               |  209
> > ++++++++++++++++++++
> > >  include/dt-bindings/clock/exynos5410.h             |   33 ++++
> > >  4 files changed, 288 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/clock/exynos5410-
> > clock.txt
> > >  create mode 100644 drivers/clk/samsung/clk-exynos5410.c
> > >  create mode 100644 include/dt-bindings/clock/exynos5410.h
> > >
> > > diff --git a/Documentation/devicetree/bindings/clock/exynos5410-
> > clock.txt b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
> > > new file mode 100644
> > > index 0000000..aeab635
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/clock/exynos5410-clock.txt
> > > @@ -0,0 +1,45 @@
> > > +* Samsung Exynos5410 Clock Controller
> > > +
> > > +The Exynos5410 clock controller generates and supplies clock to various
> > > +controllers within the Exynos5410 SoC.
> > > +
> > > +Required Properties:
> > > +
> > > +- compatible: should be "samsung,exynos5410-clock"
> > > +
> > > +- reg: physical base address of the controller and length of memory
> > mapped
> > > +  region.
> > > +
> > > +- #clock-cells: should be 1.
> > > +
> > > +All available clocks are defined as preprocessor macros in
> > > +dt-bindings/clock/exynos5410.h header and can be used in device
> > > +tree sources.
> > > +
> > > +External clock:
> > > +
> > > +There is clock that is generated outside the SoC. It
> > > +is expected that it is defined using standard clock bindings
> > > +with following clock-output-name:
> > > +
> > > + - "fin_pll" - PLL input clock from XXTI
> > 
> > Does fin_pll feed into the exynos5410-clock controller? If so, should
> > the example clock-controller node below have a clocks and clock-names
> > property?
> > 
> Well, it is fixed clocks and generated outside of the SoC...so maybe the properties are not required?

I guess the fin_pll parts of the binding description are not needed
then. This isn't a big issue, but I think that someone reading that
binding (like myself) might conclude that there is some relationship
between the clock controller and the external clock, which seems not to
be the case.

> 
> BTW, I've applied this series with Tomasz Figa's reviewed tag and sent out to arm-soc today so if any concerns on this, please let me know immediately.

As far as I can tell the fin_pll paragraph can be removed at a later
date. It isn't part of any real DT binding description such as a
property or definition. So no need to cause havoc for your existing pull
request.

Regards,
Mike

> 
> > Otherwise patch looks good.
> > 
> 
> Thanks,
> Kukjin
> 
