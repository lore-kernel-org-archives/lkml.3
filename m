Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048AbaCJPj7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 11:39:59 -0400
Received: from moutng.kundenserver.de ([212.227.17.13]:50540 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752880AbaCJPj6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 11:39:58 -0400
Date: Mon, 10 Mar 2014 16:39:52 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Alan Cox <alan@linux.intel.com>
cc: arve@android.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        mikechan@google.com
Subject: Re: [PATCH 00/10] goldfish: rebase/resend versus current -next
In-Reply-To: <20130109142212.9239.62026.stgit@bob.linux.org.uk>
Message-ID: <Pine.LNX.4.64.1403101636060.2407@axis700.grange>
References: <20130109142212.9239.62026.stgit@bob.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:r8BgXNfMNqgb2FRcmDTCwI+tyD3gluRMNGiCUIaQb0J
 WE7OmhcTXoxT+qj9lK3ZxvwfFXLeuM34LCeHAM7CRhb1uAR03G
 C75OxRf2H9CdHUWjo8Zk3ySt6bzPzpf0R7HbauHX67kYu3LLO+
 3vdTAm4OW2pqep1RQXoKq/qoOBscxCDGMtWpYK4n/UpZzG6mGr
 7nnDn2AVl3+XSaczfHvf6rUzJP+CtdUVZupZ470SJf1nBz+o3t
 N6yYY4+fJin1+6/+s8fXv6LSMj3VQ4p8JiUj3UWHxkZJFUxjiP
 aokh2eCN8PKdej07WrZ1WOZ47WYOQxLzkjGxr/UjAWV4OPEain
 /MfyWoh/V8p48xEHGcG787Ok1VPQcDy4I508wt68Im8Tyyh6rP
 9RkQgCPPmFBTg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I'm currently trying to build and run a recent kernel with x86 goldfish 
and failing. The android emulator itself is running, I can also build and 
run 3.4-based Google x86 goldfish branch, but not current (vanilla) 
kernels. Did you run tests yourself? Do you remember, what was needed - 
just the mainline kernel with these patches or any additional ones? Have 
you got a kernel configuration and command line? Any idea what the last 
working kernel version was?

Thanks
Guennadi

On Wed, 9 Jan 2013, Alan Cox wrote:

> And added the pipe driver
> 
> ---
> 
> Arve Hjønnevåg (4):
>       goldfish: tty driver
>       goldfish: framebuffer
>       goldfish: real time clock
>       goldfish: NAND flash driver
> 
> Brian Swetland (1):
>       goldfish: virtual input event driver
> 
> David 'Digit' Turner (1):
>       goldfish: add QEMU pipe driver
> 
> Jun Nakajima (2):
>       goldfish: definitions for Goldfish on x86 platforms
>       goldfish: add the goldfish virtual bus
> 
> Mike Lockwood (2):
>       goldfish: emulated MMC device
>       goldfish: power device
> 
> 
>  arch/x86/Kconfig                          |   12 +
>  arch/x86/include/asm/goldfish.h           |   40 ++
>  drivers/input/keyboard/Kconfig            |   11 +
>  drivers/input/keyboard/Makefile           |    1 
>  drivers/input/keyboard/goldfish_events.c  |  199 +++++++++
>  drivers/mmc/host/Kconfig                  |    7 
>  drivers/mmc/host/Makefile                 |    1 
>  drivers/mmc/host/goldfish.c               |  577 +++++++++++++++++++++++++++
>  drivers/mtd/devices/Kconfig               |    7 
>  drivers/mtd/devices/Makefile              |    3 
>  drivers/mtd/devices/goldfish_nand.c       |  475 ++++++++++++++++++++++
>  drivers/mtd/devices/goldfish_nand_reg.h   |   72 +++
>  drivers/platform/Kconfig                  |    4 
>  drivers/platform/Makefile                 |    1 
>  drivers/platform/goldfish/Kconfig         |    5 
>  drivers/platform/goldfish/Makefile        |    5 
>  drivers/platform/goldfish/goldfish_pipe.c |  631 +++++++++++++++++++++++++++++
>  drivers/platform/goldfish/pdev_bus.c      |  265 ++++++++++++
>  drivers/power/Kconfig                     |    8 
>  drivers/power/Makefile                    |    1 
>  drivers/power/goldfish_battery.c          |  262 ++++++++++++
>  drivers/rtc/Kconfig                       |    9 
>  drivers/rtc/Makefile                      |    1 
>  drivers/rtc/rtc-goldfish.c                |  144 +++++++
>  drivers/tty/Kconfig                       |    6 
>  drivers/tty/Makefile                      |    1 
>  drivers/tty/goldfish.c                    |  340 ++++++++++++++++
>  drivers/video/Kconfig                     |    9 
>  drivers/video/Makefile                    |    1 
>  drivers/video/goldfishfb.c                |  326 +++++++++++++++
>  30 files changed, 3422 insertions(+), 2 deletions(-)
>  create mode 100644 arch/x86/include/asm/goldfish.h
>  create mode 100644 drivers/input/keyboard/goldfish_events.c
>  create mode 100644 drivers/mmc/host/goldfish.c
>  create mode 100644 drivers/mtd/devices/goldfish_nand.c
>  create mode 100644 drivers/mtd/devices/goldfish_nand_reg.h
>  create mode 100644 drivers/platform/goldfish/Kconfig
>  create mode 100644 drivers/platform/goldfish/Makefile
>  create mode 100644 drivers/platform/goldfish/goldfish_pipe.c
>  create mode 100644 drivers/platform/goldfish/pdev_bus.c
>  create mode 100644 drivers/power/goldfish_battery.c
>  create mode 100644 drivers/rtc/rtc-goldfish.c
>  create mode 100644 drivers/tty/goldfish.c
>  create mode 100644 drivers/video/goldfishfb.c
> 
> -- 
> Moo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/
