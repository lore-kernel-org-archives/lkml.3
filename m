Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754690AbaEFUJN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:09:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49796 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbaEFUJL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:09:11 -0400
Date: Tue, 6 May 2014 15:07:50 -0500
From: Darren Etheridge <detheridge@ti.com>
To: Nishanth Menon <nm@ti.com>
CC: <balbi@ti.com>, Sricharan R <r.sricharan@ti.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <linus.walleij@linaro.org>,
        <linux@arm.linux.org.uk>, <tony@atomide.com>, <rnayak@ti.com>,
        <marc.zyngier@arm.com>, <grant.likely@linaro.org>,
        <mark.rutland@arm.com>, <tglx@linutronix.de>, <galak@codeaurora.org>,
        <santosh.shilimkar@ti.com>, <bcousson@baylibre.com>,
        <robherring2@gmail.com>
Subject: Re: [PATCH V5 1/3] arm: dts: dra7: Add crossbar device binding
Message-ID: <20140506200750.GE2626@ti.com>
References: <1399384579-25620-1-git-send-email-r.sricharan@ti.com>
 <1399384579-25620-2-git-send-email-r.sricharan@ti.com>
 <20140506194055.GA6962@saruman.home>
 <53693C02.2090305@ti.com>
 <20140506195804.GD2626@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140506195804.GD2626@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darren Etheridge <detheridge@ti.com> wrote on Tue [2014-May-06 14:58:04 -0500]:
> Nishanth Menon <nm@ti.com> wrote on Tue [2014-May-06 14:46:10 -0500]:
> > On 05/06/2014 02:40 PM, Felipe Balbi wrote:
> > > On Tue, May 06, 2014 at 07:26:17PM +0530, Sricharan R wrote:
> > >> This adds the irq crossbar device node.
> > >>
> > >> There is a IRQ crossbar device in the soc, which
> > >> maps the irq requests from the peripherals to the
> > >> mpu interrupt controller's inputs. The Peripheral irq
> > >> requests are connected to only one crossbar
> > >> input and the output of the crossbar is connected to only one
> > >> controller's input line. The crossbar device is used to map
> > >> a peripheral input to a free mpu's interrupt controller line.
> > >>
> > >> Cc: Benoit Cousson <bcousson@baylibre.com>
> > >> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> > >> Cc: Rajendra Nayak <rnayak@ti.com>
> > >> Cc: Tony Lindgren <tony@atomide.com>
> > >> Signed-off-by: Sricharan R <r.sricharan@ti.com>
> > >> Signed-off-by: Nishanth Menon <nm@ti.com>
> > >> ---
> > >> [V5] Rebased on top of 3.15-rc4 and corrected the
> > >>      irqs-reserved list
> > >>
> > >>  arch/arm/boot/dts/dra7.dtsi |    8 ++++++++
> > >>  1 file changed, 8 insertions(+)
> > >>
> > >> diff --git a/arch/arm/boot/dts/dra7.dtsi b/arch/arm/boot/dts/dra7.dtsi
> > >> index 149b550..0274a86 100644
> > >> --- a/arch/arm/boot/dts/dra7.dtsi
> > >> +++ b/arch/arm/boot/dts/dra7.dtsi
> > >> @@ -790,6 +790,14 @@
> > >>  			status = "disabled";
> > >>  		};
> > >>  	};
> > >> +
> > >> +	crossbar_mpu: crossbar@4a020000 {
> > > 
> > > shouldn't this be "status = disabled"; so that boards enable this
> > > on-demand ??
> > > 
> > It cannot be and does not need to be. crossbar is an SoC feature. by
> > defining crossbar, the IRQ numbers we provide in DTS now becomes
> > crossbar numbers which get mapped to GIC interrupt numbers dynamically.
> > 
> > further crossbar is not a board feature. it is as ingrained in DRA7
> > behavior as GIC is. we are fortunate that we have some default mapping
> > of crossbar that allows the current peripherals to work, with this
> > support, we dont have to depend any longer on "we are lucky that is
> > mapped".
> > 
> > That said, in hindsight, patch #1 and 2 should be squashed IMHO. else
> > we have a bisectability problem here.
> > 
> Yes the bisectability problem is completely true - I was just testing
> that as your email came in.  In fact I think all three patches need to
> be squashed into one, I can't boot the dra7-EVM unless I have all three
> patches applied.
> 

Or I just tried reordering, so patch 3/3 becomes patch 1 and then squash
patch 1/3 and patch 2/3 together to form patch 2.  That seems to at
least let the kernel boot to completion.

Darren
