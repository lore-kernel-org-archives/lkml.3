Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751852AbaAOIe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 03:34:58 -0500
Received: from 3.mo5.mail-out.ovh.net ([46.105.40.108]:58132 "EHLO
	mo5.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751647AbaAOIew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 03:34:52 -0500
MIME-Version: 1.0
In-Reply-To: <52D56BB2.1050301@atmel.com>
References: <1389270709-32662-1-git-send-email-jjhiblot@traphandler.com>
	<52D56BB2.1050301@atmel.com>
Date: Wed, 15 Jan 2014 09:34:39 +0100
Message-ID: <CACh+v5OSBxudDN2vpRWLuP+TwqCNT3Fv21cJc1whU90v1MysfQ@mail.gmail.com>
Subject: Re: [PATCH v2 00/12] Device Tree support for the at91sam9261ek
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        boris brezillon <b.brezillon@overkiz.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 5195465121817516056
X-Ovh-Remote: 209.85.192.181 (mail-pd0-f181.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrfeekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014/1/14 Nicolas Ferre <nicolas.ferre@atmel.com>:
> On 09/01/2014 13:31, Jean-Jacques Hiblot :
>> This patch set aims at bringing a basic device tree support for the sam9261.
>> It's mostly based on the sam9263 stuff.
>
> Nice! Thanks a lot for stepping up.
>
> One general comment though: I would like to have new AT91 SoC described
> in DT integrating mainline with Common Clock Framework implemented.
> I feel that it would make sense to directly convert sam9261 to CCF to
> avoid the pain of an intermediary DT description that would last only
> for a couple of kernel revisions.
This is a work in progress. I'm doing it on top of this patch serie.
>
>> It introduces a new driver for the smc/ebi bus. It's used to configure the EBI
>> from the DT. I haven't documented its DT bindings yet. Timings can be provided
>> as raw values or nanoseconds.
>
> Thanks a lot for taking this SMC-as-a-driver task: it is very cool to
> have it!
>
> I will try to review your patches in the coming days... But Boris
> already did a good job at this ;-)
>
>> Change since V1:
>> * changed the DT representation to use address translation and separate the
>>   timings' configuration from the device properties by adding a "simple-bus"
>>   inetrmediate node.
>> * moved the smc driver from drivers/bus to drivers/memmory
>> * smc driver now accepts timings in nanoseconds as well as raw register values
>> * smc driver can clip the timings if they're out of bound and dump them to the
>>   console
>> * DM9000 timings are now described in nanosecs (for the virtue of example)
>>
>> supported features:
>> * dbgu
>> * nand
>> * lcd
>> * ethernet
>> * leds
>>
>> Jean-Jacques
>>
>> Jean-Jacques Hiblot (12):
>>   at91: dt: Add at91sam9261 dt SoC support
>>   at91: dt: sam9261: Basic Device Tree support for the at91sam9261ek
>>   at91: dt: sam9261: Added support for the lcd display
>>   at91: smc: export sam9_smc_cs_read and sam9_smc_cs_configure.
>>   at91: smc: Increased the size of tdf_cycles in struct sam9_smc_config.
>>   at91: smc: Adds helper functions to validate and clip the smc timings.
>>   at91: dt: smc: Added smc bus driver
>>   at91: sam9261: Add a clock definition for the smc
>>   at91: dt: sam9261: Pinmux DT entries for the SMC/EBI interface
>>   at91: dt: sam9261: Add an entry in the DT for the SMC/EBI bus driver.
>>   at91: dt: sam9261: moved the NAND under the smc node
>>   at91: dt: sam9261: Added DM9000 in the device tree
>>
>>  arch/arm/boot/dts/Makefile                     |   2 +
>>  arch/arm/boot/dts/at91sam9261.dtsi             | 639 +++++++++++++++++++++++++
>>  arch/arm/boot/dts/at91sam9261ek.dts            | 164 +++++++
>>  arch/arm/mach-at91/at91sam9261.c               |  17 +
>>  arch/arm/mach-at91/include/mach/at91sam9_smc.h |   6 +-
>>  arch/arm/mach-at91/sam9_smc.c                  |  81 +++-
>>  drivers/memory/Kconfig                         |  10 +
>>  drivers/memory/Makefile                        |   1 +
>>  drivers/memory/atmel-smc.c                     | 431 +++++++++++++++++
>>  9 files changed, 1348 insertions(+), 3 deletions(-)
>>  create mode 100644 arch/arm/boot/dts/at91sam9261.dtsi
>>  create mode 100644 arch/arm/boot/dts/at91sam9261ek.dts
>>  create mode 100644 drivers/memory/atmel-smc.c
>>
>
>
> --
> Nicolas Ferre
