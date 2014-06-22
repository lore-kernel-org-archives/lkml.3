Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185AbaFVSm1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jun 2014 14:42:27 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:55825 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751782AbaFVSmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jun 2014 14:42:25 -0400
Date: Sun, 22 Jun 2014 20:41:24 +0200
From: Steffen Trumtrar <s.trumtrar@pengutronix.de>
To: Thor Thayer <tthayer.linux@gmail.com>
Cc: Thor Thayer <tthayer@altera.com>, Rob Herring <robherring2@gmail.com>,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>, linux@arm.linux.org.uk,
        Dinh Nguyen <dinguyen@altera.com>, dougthompson@xmission.com,
        Grant Likely <grant.likely@linaro.org>, Borislav Petkov <bp@alien8.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org
Subject: Re: [PATCHv6 1/3] devicetree: Addition of the Altera SDRAM controller
Message-ID: <20140622184124.GC8053@pengutronix.de>
References: <1403306523-4174-2-git-send-email-tthayer@altera.com>
 <20140621090446.GA8053@pengutronix.de>
 <CAF03EBeUdrqfjOPCf4XxaKL_ZSqAcrgSbpDfTKov9_5oG4-Btg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF03EBeUdrqfjOPCf4XxaKL_ZSqAcrgSbpDfTKov9_5oG4-Btg@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 20:39:27 up 60 days, 12:10, 23 users,  load average: 0,10, 0,08,
 0,09
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: str@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 01:31:02PM -0500, Thor Thayer wrote:
> On Sat, Jun 21, 2014 at 4:04 AM, Steffen Trumtrar
> <s.trumtrar@pengutronix.de> wrote:
> > Hi!
> >
> > On Fri, Jun 20, 2014 at 06:22:01PM -0500, tthayer@altera.com wrote:
> >> From: Thor Thayer <tthayer@altera.com>
> >>
> >> Addition of the Altera SDRAM Controller bindings and device tree changes.
> >>
> >> v2: Changes to SoC SDRAM EDAC code.
> >>
> >> v3: Implement code suggestions for SDRAM EDAC code.
> >>
> >> v4: Remove syscon from SDRAM controller bindings.
> >>
> >> v5: No Change, bump version for consistency.
> >>
> >> v6: Only map the ctrlcfg register as syscon.
> >>
> >> Signed-off-by: Thor Thayer <tthayer@altera.com>
> >> ---
> >>  .../bindings/arm/altera/socfpga-sdram.txt          |   11 +++++++++++
> >>  arch/arm/boot/dts/socfpga.dtsi                     |    5 +++++
> >>  2 files changed, 16 insertions(+)
> >>  create mode 100644 Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> >>
> >> diff --git a/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> >> new file mode 100644
> >> index 0000000..5027026
> >> --- /dev/null
> >> +++ b/Documentation/devicetree/bindings/arm/altera/socfpga-sdram.txt
> >> @@ -0,0 +1,11 @@
> >> +Altera SOCFPGA SDRAM Controller
> >> +
> >> +Required properties:
> >> +- compatible : "altr,sdr-ctl";
> >> +- reg : Should contain 1 register ranges(address and length)
> >> +
> >> +Example:
> >> +     sdrctl@ffc25000 {
> >> +             compatible = "altr,sdr-ctl";
> >> +             reg = <0xffc25000 0x4>;
> >> +     };
> >> diff --git a/arch/arm/boot/dts/socfpga.dtsi b/arch/arm/boot/dts/socfpga.dtsi
> >> index 4676f25..310292e 100644
> >> --- a/arch/arm/boot/dts/socfpga.dtsi
> >> +++ b/arch/arm/boot/dts/socfpga.dtsi
> >> @@ -682,6 +682,11 @@
> >>                       clocks = <&l4_sp_clk>;
> >>               };
> >>
> >> +             sdrctl@ffc25000 {
> >> +                     compatible = "altr,sdr-ctl", "syscon";
> >
> > Did you forget to add the syscon to the binding documentation?
> >
> Hi Steffen,
> 
> I guess I'm confused about when to use syscon. In my last series, I
> was advised not to include syscon in the bindings but to use it in the
> device tree. I had been including it in the binding document until
> this patch.
> 

Oh, aha. Well, then I'm confused, too. Let's wait for one of the DT
binding guys than.

Regards,
Steffen

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
