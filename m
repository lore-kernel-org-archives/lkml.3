Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752765Ab3F0AN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 20:13:58 -0400
Received: from mail-db9lp0253.outbound.messaging.microsoft.com ([213.199.154.253]:24685
	"EHLO db9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632Ab3F0AN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 20:13:57 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VS1(zz98dI1432Ic8kzz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh2a8h668h839h944hd25hf0ah1220h1288h12a5h12a9h12bdh137ah13b6h1441h14ddh1504h1537h153bh162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1155h)
Date: Wed, 26 Jun 2013 19:12:55 -0500
From: Scott Wood <scottwood@freescale.com>
To: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [1/1] Add a new platform tree for ib8315. Also add the DTS and
 the defconfig for that board.
Message-ID: <20130627001255.GA8931@home.buserror.net>
References: <1363614452-1109-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1363614452-1109-1-git-send-email-Sergey.Gerasimov@astrosoft-development.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please keep subject lines limited to 60-70 characters, and prefix with
"powerpc/83xx:".

On Mon, Mar 18, 2013 at 05:47:32PM +0400, Sergey Gerasimov wrote:
> Signed-off-by: Sergey Gerasimov <Sergey.Gerasimov@astrosoft-development.com>
> 
> ---
> arch/powerpc/boot/dts/ib8315.dts           |  490 +++++++
>  arch/powerpc/configs/83xx/ib8315_defconfig | 2121 ++++++++++++++++++++++++++++
>  arch/powerpc/platforms/83xx/Kconfig        |    7 +
>  arch/powerpc/platforms/83xx/Makefile       |    1 +
>  arch/powerpc/platforms/83xx/tqm8315.c      |  137 ++
>  5 files changed, 2756 insertions(+)
>  create mode 100644 arch/powerpc/boot/dts/ib8315.dts
>  create mode 100644 arch/powerpc/configs/83xx/ib8315_defconfig
>  create mode 100644 arch/powerpc/platforms/83xx/tqm8315.c

As Kumar asked, why is the device tree "ib8315" but the platform file
"tqm8315"?

Why does this board need its own defconfig, versus being added to
mpc83xx_defconfig?  Also make sure that you run savedefconfig when you
add or modify a defconfig, to trim it down to options that deviate from
the default.

> diff --git a/arch/powerpc/boot/dts/ib8315.dts b/arch/powerpc/boot/dts/ib8315.dts
> new file mode 100644
> index 0000000..963caf2
> --- /dev/null
> +++ b/arch/powerpc/boot/dts/ib8315.dts
> @@ -0,0 +1,490 @@
> +/*
> + * IB8315 Device Tree Source based on:
> + * TQM8315 Device Tree Source
> + *
> + * Copyright 2009 TQ Components
> + *
> + * This program is free software; you can redistribute  it and/or modify it
> + * under  the terms of  the GNU General  Public License as published by the
> + * Free Software Foundation;  either version 2 of the  License, or (at your
> + * option) any later version.
> + */
> +
> +/dts-v1/;
> +
> +/ {
> +	compatible = "fsl,tqm8315";

And here's tqm8315 again.  Just because you based this on tqm8315 doesn't
mean you can call it a tqm8315.

> +			partition@2 {
> +				label = "env2";
> +				reg = <0xA0000 0x40000>;	// 384 KiB
> +				read-only;
> +			};

Comment says 384 KiB.  Code says 256 KiB.

> +			partition@3 {
> +				label ="dtb";
> +				reg = <0x100000 0x100000>;	// 1 MiB
> +			};

Space after =

> +			partition@5 {
> +				label ="root";
> +				reg = <0x500000 0x2800000>;	// 40 MiB
> +			};
> +
> +			/*
> +			 * The remaining 19 MiB, e.g. for a file system.
> +			 * Requires MTD concatenation support
> +			 */
> +			partition@6 {
> +				label ="user";
> +				reg = <0x2D00000 0x1300000>;
> +			};

Nothing between 0x2800000 and 0x2d00000?

> +		nand@1,0 {
> +			#address-cells = <1>;
> +			#size-cells = <1>;
> +			compatible = "fsl,mpc8315-fcm-nand",
> +			             "fsl,elbc-fcm-nand";
> +			reg = <0x1 0x0 0x8000>;
> +
> +			partition@0 {
> +				label = "filesystem";
> +				reg = <0x0 0x20000000>;
> +				/*read-only;*/
> +			};
> +		};

No need to define a partition at all if you're giving it all to one use.

> +	immr@e0000000 {
> +		#address-cells = <1>;
> +		#size-cells = <1>;
> +		device_type = "soc";
> +		compatible = "fsl,mpc8315-immr", "simple-bus";
> +		ranges = <0 0xe0000000 0x00100000>;
> +		reg = <0xe0000000 0x00000200>;
> +		bus-frequency = <0>;			// from bootloader

Please consider factoring this stuff out into an mpc8315 include file.

> +			/* Enable this to support sensors on STK85xxNG */
> +			/*sensor@49 {
> +				compatible = "national,lm75";
> +				reg = <0x49>;
> +			};
> +			sensor@4A {
> +				compatible = "national,lm75";
> +				reg = <0x4A>;
> +			};
> +			sensor@4B {
> +				compatible = "national,lm75";
> +				reg = <0x4B>;
> +			};*/

Does the board have them or not?  The device tree describes the hardware,
not what you want to do with it.

> +	pci0: pci@e0008500 {
> +		interrupt-map-mask = <0xf800 0x0 0x0 0x7>;
> +		/* The values are calculated the following:
> +		* The first thre values are address values as address-cells is 3
> +		* The first value is the bus number in bits 31-16 (normal 0 because masked out)
> +		* Bits 15-8 are the devfn (this is the IDSEL Line shift 3 bits to the left IDSEL AD15 is 0x78)
> +		* Bis 7-0 are unused set to 0 and mask out with the interrupt-mask value
> +		* The following two values should be 0 and masked out
> +		* The fourth value is the interrupt bis from PCI configuration header (one value as interrupt-cells is 1)
> +		* The last three values are the interrupt this interrupt is connected to.
> +		* First interrupt controller node, then the number and last the flags (8 means level low) */

/*
 * Linux multi-line
 * comment style is
 * like this
 */

Also keep line lengths under 80 columns.

"interrupt bis"?

> +# CONFIG_DEBUG_BUGVERBOSE is not set

Please reconsider this one.  It makes BUG dumps much more readable, and
doesn't cost much.

> +#define MPC8315_SATA_PHYCTRL_REG_OFFSET	0x15C
> +#define PHYCTRLCFG_REFCLK_MASK		0x00000070
> +#define PHYCTRLCFG_REFCLK_50MHZ		0x00000050
> +#define PHYCTRLCFG_REFCLK_75MHZ		0x00000000
> +#define PHYCTRLCFG_REFCLK_100MHZ	0x00000060
> +#define PHYCTRLCFG_REFCLK_125MHZ	0x00000070
> +#define PHYCTRLCFG_REFCLK_150MHZ	0x00000020
> +
> +
> +#ifdef CONFIG_SATA_FSL
> +void init_mpc8315_sata_phy(void)
> +{
> +	u32 val32;
> +	void __iomem *immap;
> +
> +	immap = ioremap(get_immrbase() + 0x18000, 0x1000);
> +	if (immap == NULL)
> +		return;
> +
> +	/* Configure PHY for 125 MHz reference clock */
> +	val32 = ioread32(immap + MPC8315_SATA_PHYCTRL_REG_OFFSET);
> +	val32 &= ~PHYCTRLCFG_REFCLK_MASK;
> +	val32 |= PHYCTRLCFG_REFCLK_125MHZ;
> +	iowrite32(val32, immap + MPC8315_SATA_PHYCTRL_REG_OFFSET);
> +
> +	iounmap(immap);
> +}
> +#endif

Please use the device tree to find the regs you want, rather than
get_immrbase().  If the regs aren't already in the device tree, add them.

In this case it's the SATA controller.  Is this the right way to handle
this, or should platform code (or better, the device tree) be passing
information to the SATA driver about what PHY frequency to use?  Would
this configuration survive if the SATA driver were to reset the SATA
block?

> +/*
> + * Setup the architecture
> + */
> +static void __init tqm8315_setup_arch(void)
> +{
> +#ifdef CONFIG_PCI
> +	struct device_node *np;
> +#endif
> +
> +	if (ppc_md.progress)
> +		ppc_md.progress("tqm8315_setup_arch()", 0);
> +
> +#ifdef CONFIG_PCI
> +	for_each_compatible_node(np, "pci", "fsl,mpc8349-pci")
> +		mpc83xx_add_bridge(np);
> +	for_each_compatible_node(np, "pci", "fsl,mpc8314-pcie")
> +		mpc83xx_add_bridge(np);
> +#endif

Call mpc83xx_setup_pci().

> +static void __init tqm8315_init_IRQ(void)
> +{
> +	struct device_node *np;
> +
> +	np = of_find_node_by_type(NULL, "ipic");
> +	if (!np)
> +		return;
> +
> +	ipic_init(np, 0);
> +
> +	/* Initialize the default interrupt mapping priorities,
> +	 * in case the boot rom changed something on us.
> +	 */
> +	ipic_set_default_priority();
> +}

Call mpc83xx_ipic_init_IRQ().

> +static struct of_device_id __initdata of_bus_ids[] = {
> +	{.compatible = "simple-bus"},
> +	{.compatible = "gianfar"},
> +	{},
> +};
> +
> +static int __init declare_of_platform_devices(void)
> +{
> +	of_platform_bus_probe(NULL, of_bus_ids, NULL);
> +	return 0;
> +}
> +machine_device_initcall(tqm8315, declare_of_platform_devices);

Call mpc83xx_declare_platform_devices().

-Scott

