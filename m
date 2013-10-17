Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762664Ab3JQUAo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:00:44 -0400
Received: from mail-pb0-f43.google.com ([209.85.160.43]:50287 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759508Ab3JQUAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:00:41 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Aliaksei Katovich <aliaksei.katovich@gmail.com>
Cc: Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <rob.herring@calxeda.com>,
        Tarek Dakhran <t.dakhran@samsung.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-samsung-soc@vger.kernel.org, Rob Landley <rob@landley.net>,
        Mike Turquette <mturquette@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Naour Romain <romain.naour@openwide.fr>,
        linux-arm-kernel@lists.infradead.org, Heiko Stuebner <heiko@sntech.de>
Subject: Re: [PATCH v2 0/4] Exynos 5410 Dual cluster support
References: <1381763305-7085-1-git-send-email-v.tyrtov@samsung.com>
	<87k3hc3lso.fsf@linaro.org> <20131017130435.GG3061@cat.local>
Date: Thu, 17 Oct 2013 13:00:37 -0700
In-Reply-To: <20131017130435.GG3061@cat.local> (Aliaksei Katovich's message of
	"Thu, 17 Oct 2013 16:04:35 +0300")
Message-ID: <87zjq71xcq.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Aliaksei Katovich <aliaksei.katovich@gmail.com> writes:

> hi Kevin;
>
>> Vyacheslav Tyrtov <v.tyrtov@samsung.com> writes:
>> 
>> > The series of patches represent support of Exynos 5410 SoC
>> >     
>> > The Exynos 5410 is the first Samsung SoC based on bigLITTLE architecture.
>> > Patches allow all 8 CPU cores (4 x A7 and 4 x A15) to run at the same time
>> >     
>> > Patches add new platform description, support of clock controller,
>> > dual cluster support and device tree for Exynos 5410 
>> >    
>> > Has been build on v3.12-rc5.
>> > Has been tested on Exynos 5410 reference board (exynos_defconfig).
>> 
>> Has anyone tried this on the exynos5410 based odroid-xu yet?  
>> 
>> I tried booting this on my recently arrived odroid-xu, but am not
>> getting it to boot.
>
> 	I am able to boot my odroid-xu+e to busybox with these patches applied
> 	against 3.12-rc5: exynos_defconfig and exynos5410-smdk5410.dtb were
> 	used.
>
> 	However there seem to be some issues with virq allocations, like this:

Ah, I've seen the same thing, but for me it doesn't boot reliably.
Sometimes there's an immediate fault like this[1], and once in a rare
while, it starts to boot and I see the same virq errors.

Curious what you guys are using for boot loaders.  I found some
pre-build u-boot binaries along with the necessary BL1/2 binary blobs in
the hardkernel kernel repo: https://github.com/hardkernel/linux.git
branch: origin/odroidxu-3.4.y
path: tools/hardkernel/u-boot-pre-built

Unfortunatly, that u-boot doesn't have usb networking support built in
so I couln't use u-boot to tftp the kernel, so I was able to use fasboot
to load the kernel/ramdisk, but it's very flaky.

Do you have an pointers of where to get a known working bootloader.
Ideally, a u-boot with networking/tftp support would be ideal.

Thanks,

Kevin

[1]
USB cable Connected![0x4]
Starting download of 10008576 bytes
.........
downloading of 10008576 bytes finished
Kernel size: 00296bc5
Ramdisk size: 006f3c00
Booting kernel..
## Booting kernel from Legacy Image at 40008000 ...
   Image Name:   Linux
   Image Type:   ARM Linux Kernel Image (uncompressed)
   Data Size:    2714501 Bytes = 2.6 MiB
   Load Address: 40008000
   Entry Point:  40008000
   Verifying Checksum ... OK
   XIP Kernel Image ... OK
OK 

Starting kernel ...

undefined instruction
pc : [<4000800c>]          lr : [<bfc65df4>]
sp : bfb5bbc8  ip : 00000000     fp : 00001251
r10: 00000000  r9 : 00000000     r8 : bfb5bf30
r7 : 00000000  r6 : 00000000     r5 : 40008000  r4 : bfcabac0
r3 : bfb5bfa8  r2 : 40000100     r1 : 00001251  r0 : 00000000
Flags: nZCv  IRQs off  FIQs off  Mode SVC_32
Resetting CPU ...

emmc resetting ...
resetting ...

