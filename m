Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933261Ab3E1HQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 03:16:37 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:44364 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933235Ab3E1HQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 03:16:35 -0400
Date: Tue, 28 May 2013 09:16:30 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Linux Kernel Development <linux-kernel@vger.kernel.org>
cc: linux-parisc@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-s390@vger.kernel.org
Subject: Re: Build regressions/improvements in v3.10-rc3
In-Reply-To: <alpine.DEB.2.00.1305280908430.28098@ayla.of.borg>
Message-ID: <alpine.DEB.2.00.1305280909260.29186@ayla.of.borg>
References: <alpine.DEB.2.00.1305280908430.28098@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 May 2013, Geert Uytterhoeven wrote:
> JFYI, when comparing v3.10-rc3 to v3.10-rc2[3], the summaries are:
>   - build errors: +15/-10

Ignoring the PPC64 relocation truncations in powerpc-allyesconfig:

  + error: "__sync_fetch_and_and_4" [drivers/staging/line6/line6usb.ko] undefined!:  => N/A
  + error: "__sync_fetch_and_or_4" [drivers/staging/line6/line6usb.ko] undefined!:  => N/A

parisc-allmodconfig

  + error: "devm_request_threaded_irq" [drivers/i2c/busses/i2c-designware-pci.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/input/touchscreen/st1232.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/mfd/si476x-core.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/net/ethernet/marvell/mvmdio.ko] undefined!:  => N/A
  + error: "devm_request_threaded_irq" [drivers/staging/dwc2/dwc2.ko] undefined!:  => N/A
  + error: "irq_create_mapping" [drivers/mfd/mfd-core.ko] undefined!:  => N/A
  
s390-allmodconfig, s390-allyesconfig

Related warning for the last one:

warning: (ARM_GIC && ARM_VIC && RENESAS_INTC_IRQPIN && RENESAS_IRQC && VERSATILE_FPGA_IRQ && REGMAP && GPIO_LYNXPOINT && GPIO_GRGPIO && GPIO_PCF857X && GPIO_LANGWELL && MFD_CORE && MFD_MAX77686 && MFD_MAX8997 && AB8500_CORE && MFD_LP8788 && MFD_TPS65910 && TWL4030_CORE && MFD_WM831X_I2C && MFD_WM831X_SPI && EXTCON_MAX77693) selects IRQ_DOMAIN which has unmet direct dependencies (HAVE_GENERIC_HARDIRQS)

> [1] http://kisskb.ellerman.id.au/kisskb/head/6268/ (all 120 configs)
> [3] http://kisskb.ellerman.id.au/kisskb/head/6246/ (all 120 configs)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
