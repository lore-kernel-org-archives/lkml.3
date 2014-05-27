Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752602AbaE0VgM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 17:36:12 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:55481 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbaE0VgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 17:36:10 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19TCHzjb2wHAyX7dqIZ7fX/niAcfLKcJWY=
X-DKIM: OpenDKIM Filter v2.0.1 titan C1C815812D3
Date: Tue, 27 May 2014 17:35:49 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: dts: mvebu: split SolidRun CuBox into variants
Message-ID: <20140527213549.GU8664@titan.lakedaemon.net>
References: <1401140009-31505-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1401140009-31505-2-git-send-email-sebastian.hesselbarth@gmail.com>
 <20140527161143.GS8664@titan.lakedaemon.net>
 <5384CB29.1090204@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5384CB29.1090204@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 07:28:09PM +0200, Sebastian Hesselbarth wrote:
> On 05/27/2014 06:11 PM, Jason Cooper wrote:
> > On Mon, May 26, 2014 at 11:33:29PM +0200, Sebastian Hesselbarth wrote:
> >> As Mainlining effort for SolidRun CuBox has been carried out on the
> >> Engineering Sample, the board DTS was reflecting this. Actually,
> >> SolidRun CuBox comes in three different variants: Engineering Sample (ES),
> >> production with 1GB RAM (1G), and production with 2GB RAM (2G).
> >>
> >> Therefore, we split the current dove-cubox.dts into a common board include
> >> and one board dts for each of the above variants.
> >>
> >> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> >> ---
> [...]
> >> ---
> >>  arch/arm/boot/dts/Makefile                         |  4 +++-
> >>  arch/arm/boot/dts/dove-cubox-1g.dts                | 17 ++++++++++++++++
> >>  arch/arm/boot/dts/dove-cubox-2g.dts                | 17 ++++++++++++++++
> >>  arch/arm/boot/dts/dove-cubox-es.dts                | 23 ++++++++++++++++++++++
> >>  .../boot/dts/{dove-cubox.dts => dove-cubox.dtsi}   | 17 ----------------
> >>  5 files changed, 60 insertions(+), 18 deletions(-)
> >>  create mode 100644 arch/arm/boot/dts/dove-cubox-1g.dts
> >>  create mode 100644 arch/arm/boot/dts/dove-cubox-2g.dts
> >>  create mode 100644 arch/arm/boot/dts/dove-cubox-es.dts
> >>  rename arch/arm/boot/dts/{dove-cubox.dts => dove-cubox.dtsi} (86%)
> >>
> [...]
> >> diff --git a/arch/arm/boot/dts/dove-cubox-2g.dts b/arch/arm/boot/dts/dove-cubox-2g.dts
> >> new file mode 100644
> >> index 000000000000..513b6a68eba3
> >> --- /dev/null
> >> +++ b/arch/arm/boot/dts/dove-cubox-2g.dts
> >> @@ -0,0 +1,17 @@
> >> +/dts-v1/;
> >> +
> >> +#include "dove-cubox.dtsi"
> >> +
> >> +/ {
> >> +	model = "SolidRun CuBox (2G)";
> >> +	compatible = "solidrun,cubox-2g", "solidrun,cubox", "marvell,dove";
> >> +
> >> +	memory {
> >> +		device_type = "memory";
> >> +		reg = <0x00000000 0x80000000>;
> > 
> > Do you anticipate any other differences between the 1G and the 2G?
> > Otherwise, I'm inclined to just have a "solidrun,cubox".  The bootloader
> > should be setting the amount of RAM at boottime anyway.
> 
> Given the minor differences between ES and production, instead of
> 
> dove-cubox-common.dtsi
> +--> dove-cubox.dts (production)
> +--> dove-cubos-es.dts (engineering sample)
> 
> we could also just have an "overlay" for the ES like
> 
> dove-cubox.dts (production)
> +--> dove-cubox-es.dts (engineering sample)
> 
> It is not used commonly until now, maybe just a matter of taste.
> 
> Is there any version you prefer?

iiuc, overlays were intended for daughterboard (capes, etc) specific
info.  It may be useful here, but I'd like to hear from the DT
maintainers how they want it used.  eg: most popular first, like you
have it, or oldest first

dove-cubox-es.dts
+--> dove-cubox.dts

There's also what to do with the older files using #include...

In short, I'd prefer to stick to the old method until we have a good
reason to move to overlays and a recommended way to execute that.*

thx,

Jason.

* There's also the distinct possibility this was decided/announced and I
  missed it...
