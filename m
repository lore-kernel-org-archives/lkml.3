Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3COL0K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:26:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57548 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390Ab3COL0J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:26:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
Date: Fri, 15 Mar 2013 11:25:53 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: Daniel Mack <zonque@gmail.com>, Jonas Jensen <jonas.jensen@gmail.com>,
        linux@arm.linux.org.uk, linux-mmc@vger.kernel.org, jirislaby@gmail.com,
        linux-kernel@vger.kernel.org
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com> <CACmBeS05cyT8N9nZeqbJUPMSGeZYLWjL0Tu1GSZ-ms+Hjc0UoQ@mail.gmail.com> <5140C6B2.7040702@gmail.com>
In-Reply-To: <5140C6B2.7040702@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151125.53999.arnd@arndb.de>
X-Provags-ID: V02:K0:DEpHIkIffGaFy2YxsYNi5uVlxJYxMPLWWpggHot+caK
 RPzbo60pJEW1jK/QhUHLCBu2tlo2BgCnN8LrssgynbPcN93qKq
 ijnsG2Cb/rGQP2OnYzt10lieukSptjz+EUGEGtYG0sdouCEx96
 nH13UNDUIoC/8lpcdF5dAHDPYeXmdZKf/zOsF/xxKZE0QT5U2m
 oPl16s3OTGGK8rMo4vXoSfkQ2MPNIIgRiPJsUpkKDLffYLJC2p
 /xmCPLQ0Mg+A1XONTPpcHRoXj9lomtVfUCUIZex1irzi+qwZ8+
 2k0LAVttRgHDFxrqaNpIcxEL4TGLteDGxjr0w/aauz0tl9xK92
 fqlt0Jt9TqfQ80DXTJho=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 March 2013, Daniel Mack wrote:
> On 13.03.2013 16:37, Jonas Jensen wrote:
> > I ask for feedback and to submit (if possible) a new ARM SoC platform
> > port. This is now near complete (I think) (tested on UC-7112-LX Plus)
> > and applies to 2.6.34.14.
> 
> First of all - thanks for submitting to the upstream kernel!
> 
> However, your patch has many severe problems which you need to address.
> 
> * please rebase your work. 2.6.34 is almost three years old now. 3.9 is
> in it's stabilisation phase, and all new support has to be done for 3.10.
> * all new platforms must be written with device-tree support
> * all drivers must have device-tree support as well

+1 all of the above.

Also, if you want to get the port included into 3.10 or later, you need to
follow the latest platform coding standards (in order of files in your patch):

* make it a sub-item under ARCH_MULTIPLATFORM, not a separate top-level
  platform
* generate the defconfig file using 'make safedefconfig' rather than copying
  the whole .config file
* Use the dmaengine subsystem for your DMA driver and put it into drivers/dma
* Remove the board file and use a device tree for adding your platform
  devices
* Use the gpio subsystem for your gpio driver and put it into drivers/gpio
* move mach/debug-macro.S to include/debug/moxart.S
* replace entry-macro.S with a .handle_irq function in the machine
  descriptor
* move your mach/hardware.h into next to the platform C files in mach-moxart
* set the arch_reset function as machine_desc->restart
* set the arch_idle function as arm_pm_idle
* remove the CLOCK_TICK_RATE
* move your irq.c to drivers/irqchip/irq-moxart.c and use IRQ domains
* move your time.c to drivers/clocksource/clocksource-moxart.c and 
  GENERIC_CLOCKEVENTS
* configure the mxser driver using DT and remove all the #ifdef in there
* submit all device drivers to the respective subsystem maintainers
* use the generic watchdog interface in the wdt driver instead of a misc device.

	Arnd
