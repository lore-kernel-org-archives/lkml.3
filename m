Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532AbaK1PxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 10:53:14 -0500
Received: from foss-mx-na.foss.arm.com ([217.140.108.86]:41586 "EHLO
	foss-mx-na.foss.arm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750898AbaK1PxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 10:53:13 -0500
Message-ID: <1417189984.4371.12.camel@arm.com>
Subject: Re: [PATCH v2 RESEND 1/2] ARM: vexpress: Remove non-DT code
From: Pawel Moll <pawel.moll@arm.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        Mike Turquette <mturquette@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sudeep Holla <Sudeep.Holla@arm.com>
Date: Fri, 28 Nov 2014 15:53:04 +0000
In-Reply-To: <20141128153026.GU3836@n2100.arm.linux.org.uk>
References: <1416939455-1814-1-git-send-email-pawel.moll@arm.com>
	 <201411281608.34978.arnd@arndb.de>
	 <20141128153026.GU3836@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-28 at 15:30 +0000, Russell King - ARM Linux wrote:
> mmci-pl18x 10005000.mmci: no support for card's volts
> mmc0: error -22 whilst initialising SD card

Just tried it again:

--8<----------------------------
ARM Versatile Express Boot Monitor
Version:    V5.2.1
Build Date: Apr  4 2013
Daughterboard Site 1: V2P-CA9 Cortex A9
Daughterboard Site 2: Not Used
Running boot script from flash - BOOTSCRIPT
Loaded FDT - ca9
Loaded initrd - busybox
Copied 0x400000 bytes from 0x48000000 to 0x60008000
Booting kernel @ 0x60008000
Command line 'console=ttyAMA0,38400 earlyprintk debug '
initrd @ 0x70000000 (4127012 bytes)
FDT @ 0x69000000 (14048 bytes)
Uncompressing Linux... done, booting the kernel.
Booting Linux on physical CPU 0x0
Initializing cgroup subsys cpuset
Linux version 3.18.0-rc6+ (pawmol01@hornet) (gcc version 4.9.2 20140904 (prerelease) (crosstool-NG linaro-1.13.1-4.9-2014.09 - Linaro GCC 4.9-2014.09) ) #1442 SMP Mon Nov 24 16:43:30 GMT 2014
CPU: ARMv7 Processor [410fc091] revision 1 (ARMv7), cr=10c5387d
CPU: PIPT / VIPT nonaliasing data cache, VIPT aliasing instruction cache
Machine model: V2P-CA9
bootconsole [earlycon0] enabled
[...]
mmci-pl18x 10005000.mmci: Got CD GPIO
mmci-pl18x 10005000.mmci: Got WP GPIO
mmci-pl18x 10005000.mmci: Looking up vmmc-supply from device tree
mmci-pl18x 10005000.mmci: Looking up vqmmc-supply from device tree
mmci-pl18x 10005000.mmci: Looking up vqmmc-supply property in node /smb/motherboard/iofpga@7,00000000/mmci@05000 failed
mmci-pl18x 10005000.mmci: No vqmmc regulator found
mmci-pl18x 10005000.mmci: mmc0: PL180 manf 41 rev0 at 0x10005000 irq 41,42 (pio)
[...]
mmc0: new SD card at address 88f7
mmcblk0: mmc0:88f7 SD02G 1.84 GiB 
 mmcblk0: p1 p2
[...]
/ # mount /dev/mmcblk0p2 /mnt
EXT2-fs (mmcblk0p2): warning: mounting unchecked fs, running e2fsck is recommended
--8<------------------------------------

vmmc-supply is a defined as:

				vmmc-supply = <&v2m_fixed_3v3>;

which is:

                v2m_fixed_3v3: fixedregulator@0 {
                        compatible = "regulator-fixed";

and arch/arm/mach-vexpress/Kconfig says:

menuconfig ARCH_VEXPRESS
[...]
        select REGULATOR_FIXED_VOLTAGE if REGULATOR

but it doesn't select REGULATOR in result of this discussion:

http://thread.gmane.org/gmane.linux.ports.arm.kernel/223426/focus=223427

To summarize, I believe that setting CONFIG_REGULATOR=y (as in
vexpress_defconfig) should solve your issue.

Pawel

