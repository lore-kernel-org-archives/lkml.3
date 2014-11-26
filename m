Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaKZK7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 05:59:25 -0500
Received: from service87.mimecast.com ([91.220.42.44]:49469 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988AbaKZK7X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 05:59:23 -0500
Date: Wed, 26 Nov 2014 10:59:18 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Marc Zyngier <marc.zyngier@arm.com>
Cc: "arm@kernel.org" <arm@kernel.org>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>,
        Mark Rutland <Mark.Rutland@arm.com>,
        device tree <devicetree@vger.kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        LAKML <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v3 2/2] arm64: Add Juno board device tree.
Message-ID: <20141126105918.GB828@e106497-lin.cambridge.arm.com>
References: <1415727131-4572-1-git-send-email-Liviu.Dudau@arm.com>
 <1415727131-4572-3-git-send-email-Liviu.Dudau@arm.com>
 <5475ABC0.3090007@arm.com>
MIME-Version: 1.0
In-Reply-To: <5475ABC0.3090007@arm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 26 Nov 2014 10:59:20.0651 (UTC) FILETIME=[07D6C9B0:01D00968]
X-MC-Unique: 114112610592104201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 26, 2014 at 10:30:24AM +0000, Marc Zyngier wrote:
> Hi Liviu,
> 
> On 11/11/14 17:32, Liviu Dudau wrote:
> > This adds support for ARM's Juno development board (rev 0).
> > It enables most of the board peripherals: UART, I2C, USB, MMC and
> > 100Mb ethernet. There is no support at the moment for clock setting
> > and HDLCD driver which depends on it.
> > 
> > Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>
> > ---
> >  arch/arm64/boot/dts/arm/Makefile              |   1 +
> >  arch/arm64/boot/dts/arm/juno-clocks.dtsi      |  45 ++++++
> >  arch/arm64/boot/dts/arm/juno-motherboard.dtsi | 129 +++++++++++++++
> >  arch/arm64/boot/dts/arm/juno.dts              | 218 ++++++++++++++++++++++++++
> >  4 files changed, 393 insertions(+)
> >  create mode 100644 arch/arm64/boot/dts/arm/juno-clocks.dtsi
> >  create mode 100644 arch/arm64/boot/dts/arm/juno-motherboard.dtsi
> >  create mode 100644 arch/arm64/boot/dts/arm/juno.dts
> > 
> 
> [...]
> 
> > diff --git a/arch/arm64/boot/dts/arm/juno.dts b/arch/arm64/boot/dts/arm/juno.dts
> > new file mode 100644
> > index 0000000..097ecc4
> > --- /dev/null
> > +++ b/arch/arm64/boot/dts/arm/juno.dts
> 
> [...]
> 
> > +       timer {
> > +               compatible = "arm,armv8-timer";
> > +               interrupts = <GIC_PPI 13 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> > +                            <GIC_PPI 14 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> > +                            <GIC_PPI 11 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>,
> > +                            <GIC_PPI 10 (GIC_CPU_MASK_SIMPLE(6) | IRQ_TYPE_EDGE_RISING)>;
> > +       };
> 
> Sorry, I should have spotted this earlier: all these interrupts are
> *level*, not edge. This happens to work because the GIC's config
> register is RO for PPIs on Juno, but still...

Yes, I've seen your other email to Suravee regarding interrupt triggering and I was trying to
find the relevant bits in Juno to tell me why I've put the info in DT this way. Maybe I *did*
copy-paste this part from FVP DT though.

I will send a patch to Olof to update.

Best regards,
Liviu

> 
> Thanks,
> 
> 	M.
> -- 
> Jazz is not dead. It just smells funny...
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

