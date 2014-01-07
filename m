Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751840AbaAGJWq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 04:22:46 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:41457 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaAGJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 04:22:43 -0500
MIME-Version: 1.0
In-Reply-To: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
References: <1387807592-26375-1-git-send-email-ard.biesheuvel@linaro.org>
Date: Tue, 7 Jan 2014 10:22:41 +0100
Message-ID: <CAKv+Gu_o1TEDUYPzUCV1x6D79saUyLdJb1L59GDPwD393CzynQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/5] arm64: advertise availability of CRC and crypto instructions
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Catalin Marinas <catalin.marinas@arm.com>, viro@zeniv.linux.org.uk,
        Nicolas Pitre <nico@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

@Russell, Nico,

Care to share your opinion on this alternative approach to allocating
hwcap feature bits for the ARMv8 Crypto Extensions for 32-bit ARM?

Regards,
Ard.


On 23 December 2013 15:06, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
> This series is a followup to the patch that was recently merged by Catalin that
> allocates hwcaps bits for CRC and Crypto Extensions instructions so userland can
> discover whether the current CPU has any of those capabilities.
>
> Patch #1 enables ARM support for the ELF_HWCAP2/AT_HWCAP2 ELF auxv entry that
> was recently added to the kernel and glibc (2.18). It extends the feature bit
> space to 64 bits (on 32-bit architectures)
>
> Patch #2 adds generic support for ELF_HWCAP2/AT_HWCAP2 to the 32-bit ELF compat
> mode for 64-bit architectures.
>
> Patch #3 adds support for ELF_HWCAP2/AT_HWCAP2 to arm64's 32-bit ELF compat mode
>
> Patch #4 allocates the HWCAP2 bits in the arch/arm tree. This is necessary
> because 32-bit ARM binaries can execute both under ARM and under arm64 kernels,
> so there should be agreement about the meaning of feature bits, even if the ARM
> kernel has no support yet for ARMv8 32-bit only hardware (such as ARMv8-R)
>
> Patch #5 advertises the CRC and Crypto Extensions to 32-bit ELF binaries running
> under an arm64 kernel.
>
> v2 changes:
> - omitted 2 arm64 specific patches that have already been merged by Catalin
> - move ARM feature bits to HWCAP2
>
> Ard Biesheuvel (5):
>   ARM: add support for AT_HWCAP2 ELF auxv entry
>   binfmt_elf: add ELF_HWCAP2 to compat auxv entries
>   arm64: add AT_HWCAP2 support for 32-bit compat
>   ARM: introduce HWCAP2 feature bits for ARMv8 Crypto Extensions
>   arm64: advertise ARMv8 extensions to 32-bit compat ELF binaries
>
>  arch/arm/include/asm/hwcap.h      |  3 ++-
>  arch/arm/include/uapi/asm/hwcap.h |  9 +++++++++
>  arch/arm/kernel/setup.c           | 16 ++++++++++++++++
>  arch/arm64/include/asm/hwcap.h    |  9 ++++++++-
>  arch/arm64/kernel/setup.c         | 33 +++++++++++++++++++++++++++++++++
>  fs/compat_binfmt_elf.c            |  5 +++++
>  6 files changed, 73 insertions(+), 2 deletions(-)
>
> --
> 1.8.3.2
>
