Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496AbaE1IXO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 04:23:14 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:41167 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754471AbaE1IXK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 04:23:10 -0400
MIME-Version: 1.0
In-Reply-To: <5840140.8yGnd4Ycx3@wuerfel>
References: <1398353407-2345-1-git-send-email-santosh.shilimkar@ti.com>
	<5279118.J5305KQNjB@wuerfel>
	<20140527125655.63A46C40FCB@trevor.secretlab.ca>
	<5840140.8yGnd4Ycx3@wuerfel>
Date: Wed, 28 May 2014 10:23:09 +0200
Message-ID: <CACRpkdZjEVYgq7tKEfmZC0Fu4n=JuUues=pAAtquLahkex=pkA@mail.gmail.com>
Subject: Re: [PATCH v3 4/7] of: configure the platform device dma parameters
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Grant Likely <grant.likely@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Rob Herring <robh+dt@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Olof Johansson <olof@lixom.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 27, 2014 at 3:30 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 27 May 2014 13:56:55 Grant Likely wrote:

>> Come to think of it, doesn't PCI DMA have to deal with that situation if
>> the PCI window is not 1:1 mapped into the CPU address space?
>
> I think all PCI buses we support so far only need a single entry in the
> dma-ranges property.

Here is the patch I've cooked for the Integrator (PCIv3), identical
to the keystone:

commit b326b94a58ff476fca2b57cf7912b00bec1363c0
Author: Linus Walleij <linus.walleij@linaro.org>
Date:   Fri Feb 14 10:26:15 2014 +0100

    ARM: integrator: get rid of <mach/memory.h>

    The Integrator has a custom <mach/memory.h> header defining the
    BUS_OFFSET for *_to_bus and bus_to_* operations as offset from
    0x80000000.

    This switches the Integrator over to using the mechanism
    introduced for the Keystone to provide the same offset using
    the device tree, deletes <mach/memory.h> and augments the
    Integrator device tree to provide the bus offset.

    Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
    Cc: Grygorii Strashko <grygorii.strashko@ti.com>
    Cc: Will Deacon <will.deacon@arm.com>
    Cc: Jonathan Austin <jonathan.austin@arm.com>
    Cc: Russell King <linux@arm.linux.org.uk>
    Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
index ab438cb5af55..2b29a1a7f26f 100644
--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -329,7 +329,6 @@ config ARCH_INTEGRATOR
        select HAVE_TCM
        select ICST
        select MULTI_IRQ_HANDLER
-       select NEED_MACH_MEMORY_H
        select PLAT_VERSATILE
        select SPARSE_IRQ
        select USE_OF
diff --git a/arch/arm/boot/dts/integratorap.dts
b/arch/arm/boot/dts/integratorap.dts
index b10e6351da53..f0c397fd45c5 100644
--- a/arch/arm/boot/dts/integratorap.dts
+++ b/arch/arm/boot/dts/integratorap.dts
@@ -8,6 +8,7 @@
 / {
        model = "ARM Integrator/AP";
        compatible = "arm,integrator-ap";
+       dma-ranges = <0x80000000 0x8 0x00000000 0x80000000>;

        aliases {
                arm,timer-primary = &timer2;
diff --git a/arch/arm/mach-integrator/include/mach/memory.h
b/arch/arm/mach-integrator/include/mach/memory.h
deleted file mode 100644
index 334d5e271889..000000000000
--- a/arch/arm/mach-integrator/include/mach/memory.h
+++ /dev/null
(...)

Yours,
Linus Walleij
