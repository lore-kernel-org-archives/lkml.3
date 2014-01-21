Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193AbaAURLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 12:11:50 -0500
Received: from gate.crashing.org ([63.228.1.57]:33850 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179AbaAURLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 12:11:48 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH 1/2][v5] driver/memory:Move Freescale IFC driver to a common driver
From: Kumar Gala <galak@kernel.crashing.org>
In-Reply-To: <1390026091-25111-1-git-send-email-prabhakar@freescale.com>
Date: Tue, 21 Jan 2014 11:11:31 -0600
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Scott Wood <scottwood@freescale.com>
Content-Transfer-Encoding: 8BIT
Message-Id: <0E81C3B6-B875-4DA3-BD24-92B63C57E913@kernel.crashing.org>
References: <1390026091-25111-1-git-send-email-prabhakar@freescale.com>
To: Prabhakar Kushwaha <prabhakar@freescale.com>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 18, 2014, at 12:21 AM, Prabhakar Kushwaha <prabhakar@freescale.com> wrote:

> Freescale IFC controller has been used for mpc8xxx. It will be used
> for ARM-based SoC as well. This patch moves the driver to driver/memory
> and fix the header file includes.
> 
> Also remove module_platform_driver() and  instead call
> platform_driver_register() from subsys_initcall() to make sure this module
> has been loaded before MTD partition parsing starts.
> 
> Signed-off-by: Prabhakar Kushwaha <prabhakar@freescale.com>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> ---
> Changes for v2:
> 	- Move fsl_ifc in driver/memory
> 
> Changes for v3:
> 	- move device tree bindings to memory
> 
> Changes for v4: Rebased to 
> 	git://git.kernel.org/pub/scm/linux/kernel/git/scottwood/linux.git
> 
> Changes for v5: 
> 	- Moved powerpc/Kconfig option to driver/memory
> 
> 
> .../{powerpc => memory-controllers}/fsl/ifc.txt    |    0
> arch/powerpc/Kconfig                               |    4 ----
> arch/powerpc/sysdev/Makefile                       |    1 -
> drivers/memory/Kconfig                             |    4 ++++
> drivers/memory/Makefile                            |    1 +
> {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c  |    8 ++++++--
> drivers/mtd/nand/fsl_ifc_nand.c                    |    2 +-
> .../include/asm => include/linux}/fsl_ifc.h        |    0
> 8 files changed, 12 insertions(+), 8 deletions(-)
> rename Documentation/devicetree/bindings/{powerpc => memory-controllers}/fsl/ifc.txt (100%)
> rename {arch/powerpc/sysdev => drivers/memory}/fsl_ifc.c (98%)
> rename {arch/powerpc/include/asm => include/linux}/fsl_ifc.h (100%)
> 
> diff --git a/Documentation/devicetree/bindings/powerpc/fsl/ifc.txt b/Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
> similarity index 100%
> rename from Documentation/devicetree/bindings/powerpc/fsl/ifc.txt
> rename to Documentation/devicetree/bindings/memory-controllers/fsl/ifc.txt
> diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
> index b44b52c..83fb8b3 100644
> --- a/arch/powerpc/Kconfig
> +++ b/arch/powerpc/Kconfig
> @@ -725,10 +725,6 @@ config FSL_LBC
> 	  controller.  Also contains some common code used by
> 	  drivers for specific local bus peripherals.
> 
> -config FSL_IFC
> -	bool
> -        depends on FSL_SOC
> -
> config FSL_GTM
> 	bool
> 	depends on PPC_83xx || QUICC_ENGINE || CPM2
> diff --git a/arch/powerpc/sysdev/Makefile b/arch/powerpc/sysdev/Makefile
> index f67ac90..afbcc37 100644
> --- a/arch/powerpc/sysdev/Makefile
> +++ b/arch/powerpc/sysdev/Makefile
> @@ -21,7 +21,6 @@ obj-$(CONFIG_FSL_SOC)		+= fsl_soc.o fsl_mpic_err.o
> obj-$(CONFIG_FSL_PCI)		+= fsl_pci.o $(fsl-msi-obj-y)
> obj-$(CONFIG_FSL_PMC)		+= fsl_pmc.o
> obj-$(CONFIG_FSL_LBC)		+= fsl_lbc.o
> -obj-$(CONFIG_FSL_IFC)		+= fsl_ifc.o
> obj-$(CONFIG_FSL_GTM)		+= fsl_gtm.o
> obj-$(CONFIG_FSL_85XX_CACHE_SRAM)	+= fsl_85xx_l2ctlr.o fsl_85xx_cache_sram.o
> obj-$(CONFIG_SIMPLE_GPIO)	+= simple_gpio.o
> diff --git a/drivers/memory/Kconfig b/drivers/memory/Kconfig
> index 29a11db..b33bb0e 100644
> --- a/drivers/memory/Kconfig
> +++ b/drivers/memory/Kconfig
> @@ -50,4 +50,8 @@ config TEGRA30_MC
> 	  analysis, especially for IOMMU/SMMU(System Memory Management
> 	  Unit) module.
> 
> +config FSL_IFC
> +	bool
> +        depends on FSL_SOC
> +

I think this should be user selectable like all the other Kconfig options in drivers/memory

Also add a help description.

> endif

[ snip ]

- k

