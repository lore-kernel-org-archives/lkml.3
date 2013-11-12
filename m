Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932149Ab3KLQUe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:20:34 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:37751 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab3KLQUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:20:32 -0500
Message-ID: <5282552B.4000801@ti.com>
Date: Tue, 12 Nov 2013 11:19:55 -0500
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Khoronzhuk, Ivan" <ivan.khoronzhuk@ti.com>
CC: Rob Landley <rob@landley.net>, Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>
Subject: Re: [PATCH 12/12] arm: dts: keystone: add AEMIF/NAND device entry
References: <1384187188-5776-1-git-send-email-ivan.khoronzhuk@ti.com>,<1384187188-5776-13-git-send-email-ivan.khoronzhuk@ti.com> <4F5844B3A985794BA902E12C070812375F8D71@DNCE04.ent.ti.com>
In-Reply-To: <4F5844B3A985794BA902E12C070812375F8D71@DNCE04.ent.ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 11 November 2013 12:13 PM, Khoronzhuk, Ivan wrote:
> Add AEMIF/NAND device entry.
> 
> Signed-off-by: Ivan Khoronzhuk <ivan.khoronzhuk@ti.com>
> ---
>  arch/arm/boot/dts/keystone.dts |   63 ++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 63 insertions(+)
> 
> diff --git a/arch/arm/boot/dts/keystone.dts b/arch/arm/boot/dts/keystone.dts
> index 100bdf5..998da98 100644
> --- a/arch/arm/boot/dts/keystone.dts
> +++ b/arch/arm/boot/dts/keystone.dts
> @@ -179,5 +179,68 @@
>                         interrupts = <GIC_SPI 300 IRQ_TYPE_EDGE_RISING>;
>                         clocks = <&clkspi>;
>                 };
> +
> +               aemif@021000A00 {
> +                       compatible = "ti,keystone-aemif";
> +                       #address-cells = <2>;
> +                       #size-cells = <1>;
> +                       clocks = <&clkaemif>;
> +                       clock-names = "aemif";
> +                       clock-ranges;
> +
> +                       reg = <0x2100A00 0x00000100>;
> +                       ranges = <0 0 0x30000000 0x10000000
> +                                 1 0 0x21000A00 0x00000100>;
> +
> +                       nand:cs0 {
> +                               compatible = "ti,davinci-cs";
> +                               #address-cells = <2>;
> +                               #size-cells = <1>;
> +                               clock-ranges;
> +                               ranges;
> +
> +                               /* all timings in nanoseconds */
> +                               ti,davinci-cs-ta = <12>;
> +                               ti,davinci-cs-rhold = <6>;
> +                               ti,davinci-cs-rstrobe = <23>;
> +                               ti,davinci-cs-rsetup = <9>;
> +                               ti,davinci-cs-whold = <8>;
> +                               ti,davinci-cs-wstrobe = <23>;
> +                               ti,davinci-cs-wsetup = <8>;
> +
> +                               nand@0,0 {
> +                                       compatible = "ti,keystone-nand";
> +                                       #address-cells = <1>;
> +                                       #size-cells = <1>;
> +                                       reg = <0 0 0x4000000
> +                                              1 0 0x0000100>;
> +
> +                                       ti,davinci-chipselect = <0>;
> +                                       ti,davinci-mask-ale = <0x2000>;
> +                                       ti,davinci-mask-cle = <0x4000>;
> +                                       ti,davinci-mask-chipsel = <0>;
> +                                       nand-ecc-mode = "hw";
> +                                       ti,davinci-ecc-bits = <4>;
> +                                       nand-on-flash-bbt;
> +
> +                                       partition@0 {
> +                                               label = "u-boot";
> +                                               reg = <0x0 0x100000>;
> +                                               read-only;
> +                                       };
> +
> +                                       partition@100000 {
> +                                               label = "params";
> +                                               reg = <0x100000 0x80000>;
> +                                               read-only;
> +                                       };
> +
> +                                       partition@180000 {
> +                                               label = "ubifs";
> +                                               reg = <0x180000 0x7E80000>;
> +                                       };
Lets create now board specific k2hk-evm.dts and rename keystone.dts
to keystone.dtsi and include that in boards. That way you can add the
board specific stuff in board files and common soc stuff in keystone.dtsi.

You can update that once the bindings are blessed by DT folks.

Regards,
Santosh

