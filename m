Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645AbaLDKgD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 05:36:03 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:56702 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaLDKgA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 05:36:00 -0500
Message-ID: <5480390E.5050408@atmel.com>
Date: Thu, 4 Dec 2014 11:35:58 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        "Jean-Christophe Plagniol-Villard" <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        "Arnd Bergmann" <arnd@arndb.de>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Subject: Re: [PATCH v5 00/11] memory: add Atmel EBI (External Bus Interface)
 driver
References: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
In-Reply-To: <1417639455-17410-1-git-send-email-boris.brezillon@free-electrons.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 03/12/2014 21:44, Boris Brezillon a écrit :
> The EBI (External Bus Interface) is used to access external peripherals
> (NOR, SRAM, NAND, and other specific devices like ethernet controllers).
> Each device is assigned a CS line and an address range and can have its
> own configuration (timings, access mode, bus width, ...).
> This driver provides a generic DT binding to configure a device according
> to its requirements.
> For specific device controllers (like the NAND one) the SMC timings
> should be configured by the controller driver through the matrix and
> smc syscon regmaps.
> 
> The first 4 patches introduce 2 syscon devices needed to configure the
> EBI bus, patch 5 and 6 adds support for the EBI bus, and the remaining
> patches declares the EBI related nodes in sama5d3 dts[i] files.
> 
> Changes since v4:
> - fix inconsistencies in SMC and MATRIX registers definition
> - add missing compatible strings for at91sam9rl SoC
> - fix DT bindings documentation
> - replace "atmel,generic-dev" property by "atmel,specialized-logic"
> 
> Changes since v3:
> - added AT91_MATRIX_USBPUCR_PUON definition
> - removed useless macros (those directly returning SoC specific register
>   offsets)
> - use syscon_regmap_lookup_by_phandle instead of of_parse_phandle +
>   syscon_node_to_regmap
> - drop AT91_EBICSA_REGFIELD and AT91_MULTI_EBICSA_REGFIELD macros
> 
> Changes since v2:
> - minor fixes int DT bindings doc
> - fix SMC macros
> - make use of SMC macros defined in include/linux/mfd/syscon/atmel-smc.h
> 
> Changes since v1:
> - almost everything :-)
> 
> Boris Brezillon (11):
>   mfd: syscon: Add atmel-matrix registers definition
>   mfd: syscon: Add Atmel Matrix bus DT binding documentation
>   mfd: syscon: Add atmel-smc registers definition
>   mfd: syscon: Add Atmel SMC binding doc
>   memory: add Atmel EBI (External Bus Interface) driver
>   memory: atmel-ebi: add DT bindings documentation
>   ARM: at91: select ATMEL_EBI when compiling a kernel for at91sam9 or
>     sama5d3
>   ARM: at91/dt: add HSMC (Static Memory Controller) node in sama5d3 dtsi
>   ARM: at91/dt: add matrix node in sama5d3 dtsi
>   ARM: at91/dt: add EBI (External Bus Interface) node in sama5d3 dtsi
>   ARM: at91/dt: add NOR definition in sama5d3xcm dtsi

The whole series seems okay.

If you reorder the content of the patches as noted, you can add my:
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Thanks bye.

>  .../bindings/memory-controllers/atmel-ebi.txt      | 155 ++++++
>  .../devicetree/bindings/mfd/atmel-matrix.txt       |  24 +
>  .../devicetree/bindings/mfd/atmel-smc.txt          |  19 +
>  arch/arm/boot/dts/sama5d3.dtsi                     |  93 ++++
>  arch/arm/boot/dts/sama5d3xcm.dtsi                  |  33 ++
>  arch/arm/mach-at91/Kconfig                         |   2 +
>  drivers/memory/Kconfig                             |  11 +
>  drivers/memory/Makefile                            |   1 +
>  drivers/memory/atmel-ebi.c                         | 579 +++++++++++++++++++++
>  include/linux/mfd/syscon/atmel-matrix.h            | 117 +++++
>  include/linux/mfd/syscon/atmel-smc.h               | 173 ++++++
>  11 files changed, 1207 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/memory-controllers/atmel-ebi.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-matrix.txt
>  create mode 100644 Documentation/devicetree/bindings/mfd/atmel-smc.txt
>  create mode 100644 drivers/memory/atmel-ebi.c
>  create mode 100644 include/linux/mfd/syscon/atmel-matrix.h
>  create mode 100644 include/linux/mfd/syscon/atmel-smc.h
> 


-- 
Nicolas Ferre
