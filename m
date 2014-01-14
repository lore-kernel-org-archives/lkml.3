Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592AbaANQyR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 11:54:17 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:25576 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbaANQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 11:54:14 -0500
Message-ID: <52D56BB2.1050301@atmel.com>
Date: Tue, 14 Jan 2014 17:54:10 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
CC: <b.brezillon@overkiz.com>, <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/12] Device Tree support for the at91sam9261ek
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
In-Reply-To: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/2014 13:31, Jean-Jacques Hiblot :
> This patch set aims at bringing a basic device tree support for the sam9261.
> It's mostly based on the sam9263 stuff.

Nice! Thanks a lot for stepping up.

One general comment though: I would like to have new AT91 SoC described
in DT integrating mainline with Common Clock Framework implemented.
I feel that it would make sense to directly convert sam9261 to CCF to
avoid the pain of an intermediary DT description that would last only
for a couple of kernel revisions.

> It introduces a new driver for the smc/ebi bus. It's used to configure the EBI
> from the DT. I haven't documented its DT bindings yet. Timings can be provided
> as raw values or nanoseconds.

Thanks a lot for taking this SMC-as-a-driver task: it is very cool to
have it!

I will try to review your patches in the coming days... But Boris
already did a good job at this ;-)

> Change since V1:
> * changed the DT representation to use address translation and separate the
>   timings' configuration from the device properties by adding a "simple-bus"
>   inetrmediate node.
> * moved the smc driver from drivers/bus to drivers/memmory
> * smc driver now accepts timings in nanoseconds as well as raw register values
> * smc driver can clip the timings if they're out of bound and dump them to the
>   console
> * DM9000 timings are now described in nanosecs (for the virtue of example)
> 
> supported features:
> * dbgu
> * nand
> * lcd
> * ethernet
> * leds
> 
> Jean-Jacques
> 
> Jean-Jacques Hiblot (12):
>   at91: dt: Add at91sam9261 dt SoC support
>   at91: dt: sam9261: Basic Device Tree support for the at91sam9261ek
>   at91: dt: sam9261: Added support for the lcd display
>   at91: smc: export sam9_smc_cs_read and sam9_smc_cs_configure.
>   at91: smc: Increased the size of tdf_cycles in struct sam9_smc_config.
>   at91: smc: Adds helper functions to validate and clip the smc timings.
>   at91: dt: smc: Added smc bus driver
>   at91: sam9261: Add a clock definition for the smc
>   at91: dt: sam9261: Pinmux DT entries for the SMC/EBI interface
>   at91: dt: sam9261: Add an entry in the DT for the SMC/EBI bus driver.
>   at91: dt: sam9261: moved the NAND under the smc node
>   at91: dt: sam9261: Added DM9000 in the device tree
> 
>  arch/arm/boot/dts/Makefile                     |   2 +
>  arch/arm/boot/dts/at91sam9261.dtsi             | 639 +++++++++++++++++++++++++
>  arch/arm/boot/dts/at91sam9261ek.dts            | 164 +++++++
>  arch/arm/mach-at91/at91sam9261.c               |  17 +
>  arch/arm/mach-at91/include/mach/at91sam9_smc.h |   6 +-
>  arch/arm/mach-at91/sam9_smc.c                  |  81 +++-
>  drivers/memory/Kconfig                         |  10 +
>  drivers/memory/Makefile                        |   1 +
>  drivers/memory/atmel-smc.c                     | 431 +++++++++++++++++
>  9 files changed, 1348 insertions(+), 3 deletions(-)
>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
>  create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
>  create mode 100644 drivers/memory/atmel-smc.c
> 


-- 
Nicolas Ferre
