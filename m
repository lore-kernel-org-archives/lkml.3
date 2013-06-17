Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756237Ab3FQMyM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jun 2013 08:54:12 -0400
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:16771
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752397Ab3FQMyK convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jun 2013 08:54:10 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -3
X-BigFish: VPS-3(zz9371Ic89bh542I1432Izz1f42h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ah1fc6hzz8275bhz2dh668h839h947hd25hf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh15d0h162dh1631h1758h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1155h)
X-WSS-ID: 0MOJFU2-02-0YN-02
X-M-MSG: 
From: "Deucher, Alexander" <Alexander.Deucher@amd.com>
To: Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: "Koenig, Christian" <Christian.Koenig@amd.com>,
        Jerome Glisse <jglisse@redhat.com>
Subject: RE: Regression: 3.9.0+ .. 3.10-rc5 freezes during boot, Radeon
 update ??
Thread-Topic: Regression: 3.9.0+ .. 3.10-rc5 freezes during boot, Radeon
 update ??
Thread-Index: AQHOaoB9KSLTjYro9kaZeS8nZyszTZk53PXQ
Date: Mon, 17 Jun 2013 12:54:05 +0000
Message-ID: <A3397C8B8B789E45844E7EC5DEAD89D02DF6AAD5@sausexdag04.amd.com>
References: <51BD9A65.1000902@xs4all.nl>
In-Reply-To: <51BD9A65.1000902@xs4all.nl>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.226.128.5]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Jim Bos [mailto:jim876@xs4all.nl]
> Sent: Sunday, June 16, 2013 6:59 AM
> To: Linux Kernel Mailing List
> Cc: Koenig, Christian; Jerome Glisse; Deucher, Alexander
> Subject: Regression: 3.9.0+ .. 3.10-rc5 freezes during boot, Radeon update ??
> 
> 
> Was about to test 3.10-rc5 but kernel freezes during boot.
> 
> With freeze, I mean I've to hit reset button to recover, system is
> basically dead, last line on the screen is:

Does it eventually boot after several minutes?  You may be seeing a timeout from the firmware loader as it tries to load the new ucode for the UVD block.  Make sure you  have the latest REDWOOD_rlc.bin and CYPRESS_uvd.bin files from the Linux firmware tree.

Alex


> 
> --
> fb: conflicting fb hw usage radeondrmfb vs EFI VGA - removing generic driver
> --
> 
> With a *working* boot on plain 3.9.0 I get this:
> 
> [    0.390471] efifb: probing for efifb
> [    0.390835] efifb: framebuffer at 0xc0000000, mapped to
> 0xffffc90011180000, using 6144k, total 16384k
> [    0.390837] efifb: mode is 1024x768x32, linelength=4096, pages=1
> [    0.390839] efifb: scrolling: redraw
> [    0.390840] efifb: Truecolor: size=8:8:8:8, shift=24:16:8:0
> [    0.392203] Console: switching to colour frame buffer device 128x48
> [    0.393461] fb0: EFI VGA frame buffer device
> [    0.393476] intel_idle: MWAIT substates: 0x1120
> [    0.393477] intel_idle: v0.4 model 0x2A
> [    0.393478] intel_idle: lapic_timer_reliable_states 0xffffffff
> [    0.393524] input: Power Button as
> /devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0C:00/input/input0
> [    0.393549] ACPI: Power Button [PWRB]
> [    0.393578] input: Power Button as
> /devices/LNXSYSTM:00/LNXPWRBN:00/input/input1
> [    0.393599] ACPI: Power Button [PWRF]
> [    0.393645] ACPI: Requesting acpi_cpufreq
> [    0.394908] GHES: HEST is not enabled!
> [    0.401581] Serial: 8250/16550 driver, 8 ports, IRQ sharing enabled
> [    0.422148] 00:02: ttyS0 at I/O 0x3f8 (irq = 4) is a 16550A
> [    0.422488] [drm] Initialized drm 1.1.0 20060810
> [    0.422508] [drm] radeon kernel modesetting enabled.
> [    0.422538] checking generic (c0000000 600000) vs hw (c0000000 10000000)
> [    0.422539] fb: conflicting fb hw usage radeondrmfb vs EFI VGA -
> removing generic driver
> 
> >>>>>>> here it stops for the failing boot <<<<<<<<<<<<<<<<<<<
> 
> [    0.422566] Console: switching to colour dummy device 80x25
> [    0.422680] [drm] initializing kernel modesetting (REDWOOD
> 0x1002:0x68D8 0x1682:0x3065).
> [    0.422693] [drm] register mmio base: 0xFE620000
> [    0.422695] [drm] register mmio size: 131072
> [    0.422735] ATOM BIOS: REDWOOD
> [    0.422764] radeon 0000:01:00.0: VRAM: 1024M 0x0000000000000000 -
> 0x000000003FFFFFFF (1024M used)
> [    0.422766] radeon 0000:01:00.0: GTT: 512M 0x0000000040000000 -
> 0x000000005FFFFFFF
> 
> This is the last step in git-bisect:
> 
> # git bisect good
> f2ba57b5eab8817d86d0f108fdf1878e51dc0a37 is the first bad commit
> commit f2ba57b5eab8817d86d0f108fdf1878e51dc0a37
> Author: Christian König <deathsimple@vodafone.de>
> Date:   Mon Apr 8 12:41:29 2013 +0200
> 
>     drm/radeon: UVD bringup v8
> 
>     Just everything needed to decode videos using UVD.
> 
>     v6: just all the bugfixes and support for R7xx-SI merged in one patch
>     v7: UVD_CGC_GATE is a write only register, lockup detection fix
>     v8: split out VRAM fallback changes, remove support for RV770,
>         add support for HEMLOCK, add buffer sizes checks
> 
>     Signed-off-by: Christian König <christian.koenig@amd.com>
>     Reviewed-by: Jerome Glisse <jglisse@redhat.com>
>     Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> 
> :040000 040000 1bfd368f291a2cfd7d0ebeb70c9109dfd6ebb97d
> e4307ff6aa51cf9831815528b7dcf802dd045022 M      drivers
> :040000 040000 1e16513d7c6ac3bde842a2ef9e9993ddfeb3faab
> 8a79c88d63cce4341a3885effcb69024d6d36917 M      include
> 
> I have these firmware files:
> 
> # ls -l firmware/radeon/REDWOOD_*bin
> -rw-r--r-- 1 root root 5504 Jul 22  2012 firmware/radeon/REDWOOD_me.bin
> -rw-r--r-- 1 root root 4480 Jul 22  2012 firmware/radeon/REDWOOD_pfp.bin
> -rw-r--r-- 1 root root 3072 Apr  6 11:58 firmware/radeon/REDWOOD_rlc.bin
> 
> and they are builtin into the kernel:
> # egrep "RADEON|EXTRA_FIRMWARE|KMS|^CONFIG_FB_" .config
> CONFIG_EXTRA_FIRMWARE="radeon/REDWOOD_me.bin
> radeon/REDWOOD_pfp.bin
> radeon/REDWOOD_rlc.bin"
> CONFIG_EXTRA_FIRMWARE_DIR="firmware"
> CONFIG_DRM_KMS_HELPER=y
> CONFIG_DRM_RADEON=y
> # CONFIG_DRM_RADEON_UMS is not set
> CONFIG_FB_BOOT_VESA_SUPPORT=y
> CONFIG_FB_CFB_FILLRECT=y
> CONFIG_FB_CFB_COPYAREA=y
> CONFIG_FB_CFB_IMAGEBLIT=y
> CONFIG_FB_MODE_HELPERS=y
> CONFIG_FB_TILEBLITTING=y
> CONFIG_FB_VESA=y
> CONFIG_FB_EFI=y
> # CONFIG_FB_RADEON is not set
> 
> 
> Anything else I can provide ?
> _
> Jim


