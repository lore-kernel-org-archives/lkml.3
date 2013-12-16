Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab3LPUrz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 15:47:55 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:57175 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752332Ab3LPUrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 15:47:53 -0500
MIME-Version: 1.0
In-Reply-To: <1387224459-25746-5-git-send-email-david.a.cohen@linux.intel.com>
References: <1387224459-25746-1-git-send-email-david.a.cohen@linux.intel.com> <1387224459-25746-5-git-send-email-david.a.cohen@linux.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 16 Dec 2013 13:47:32 -0700
Message-ID: <CAErSpo5tM4nF-WuUb9CH6sZ+XJ3u_U5nwg9u2cbn0EmeG1OgLg@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] x86: intel-mid: remove deprecated X86_MDFLD and
 X86_WANT_INTEL_MID configs
To: David Cohen <david.a.cohen@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 16, 2013 at 1:07 PM, David Cohen
<david.a.cohen@linux.intel.com> wrote:
> We want to support all Intel Mid platforms with a single config
> selection. This patch removes deprecated CONFIG_X86_MDFLD and
> X86_WANT_INTEL_MID options in favor of having CONFIG_X86_INTEL_MID only.
>
> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
> ---
>  arch/x86/Kconfig | 29 +++++------------------------
>  1 file changed, 5 insertions(+), 24 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index e903c71f7e69..b6a344fb01ae 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -437,42 +437,23 @@ config X86_INTEL_CE
>           This option compiles in support for the CE4100 SOC for settop
>           boxes and media devices.
>
> -config X86_WANT_INTEL_MID
> +config X86_INTEL_MID
>         bool "Intel MID platform support"
>         depends on X86_32
>         depends on X86_EXTENDED_PLATFORM
> -       ---help---
> -         Select to build a kernel capable of supporting Intel MID platform
> -         systems which do not have the PCI legacy interfaces (Moorestown,
> -         Medfield). If you are building for a PC class system say N here.
> -
> -if X86_WANT_INTEL_MID
> -
> -config X86_INTEL_MID
> -       bool
> -
> -config X86_MDFLD
> -       bool "Medfield MID platform"
>         depends on PCI
>         depends on PCI_GOANY
>         depends on X86_IO_APIC
> -       select X86_INTEL_MID
>         select SFI
> +       select I2C
>         select DW_APB_TIMER
>         select APB_TIMER
> -       select I2C
> -       select SPI
>         select INTEL_SCU_IPC
> -       select X86_PLATFORM_DEVICES
>         select MFD_INTEL_MSIC
>         ---help---
> -         Medfield is Intel's Low Power Intel Architecture (LPIA) based Moblin
> -         Internet Device(MID) platform.
> -         Unlike standard x86 PCs, Medfield does not have many legacy devices
> -         nor standard legacy replacement devices/features. e.g. Medfield does
> -         not contain i8259, i8254, HPET, legacy BIOS, most of the io ports.
> -
> -endif
> +         Select to build a kernel capable of supporting Intel MID platform
> +         systems which do not have the PCI legacy interfaces (Moorestown,
> +         Medfield). If you are building for a PC class system say N here.

It'd be nice to know what "MID" means -- from Googling, I guess
"Mobile Internet Device."

>  config X86_INTEL_LPSS
>         bool "Intel Low Power Subsystem Support"
> --
> 1.8.4.2
>
