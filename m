Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751797AbaAMPks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 10:40:48 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:40759 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751396AbaAMPkp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 10:40:45 -0500
Date: Mon, 13 Jan 2014 15:40:40 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-efi@vger.kernel.org, matt.fleming@intel.com,
        roy.franz@linaro.org, msalter@redhat.com, linux@arm.linux.org.uk,
        grant.likely@secretlab.ca, patches@linaro.org,
        Arnd Bergmann <arnd@arndb.de>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v4 4/5] arm: Add [U]EFI runtime services support
Message-ID: <20140113154040.GH3256@console-pimps.org>
References: <1389445524-30623-1-git-send-email-leif.lindholm@linaro.org>
 <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389445524-30623-5-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan, at 01:05:23PM, Leif Lindholm wrote:
> This patch implements basic support for UEFI runtime services in the
> ARM architecture - a requirement for using efibootmgr to read and update
> the system boot configuration.
> 
> It uses the generic configuration table scanning to populate ACPI and
> SMBIOS pointers.
> 
> Signed-off-by: Leif Lindholm <leif.lindholm@linaro.org>
> Reviewed-by: Grant Likely <grant.likely@linaro.org>
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  arch/arm/Kconfig            |   16 ++
>  arch/arm/include/asm/uefi.h |   28 +++
>  arch/arm/kernel/Makefile    |    2 +
>  arch/arm/kernel/setup.c     |    4 +
>  arch/arm/kernel/uefi.c      |  418 +++++++++++++++++++++++++++++++++++++++++++
>  arch/arm/kernel/uefi_phys.S |   67 +++++++
>  include/linux/efi.h         |    2 +-
>  7 files changed, 536 insertions(+), 1 deletion(-)
>  create mode 100644 arch/arm/include/asm/uefi.h
>  create mode 100644 arch/arm/kernel/uefi.c
>  create mode 100644 arch/arm/kernel/uefi_phys.S

[...]

> @@ -664,7 +664,7 @@ extern int __init efi_setup_pcdp_console(char *);
>  #define EFI_64BIT		5	/* Is the firmware 64-bit? */
>  
>  #ifdef CONFIG_EFI
> -# ifdef CONFIG_X86
> +# if defined(CONFIG_X86) || defined(CONFIG_ARM)
>  extern int efi_enabled(int facility);
>  # else
>  static inline int efi_enabled(int facility)

This looks like it's going to conflict with Mark's "[PATCH 6/6] arm64:
add EFI runtime services".

Guys, what's going on here? Srsly. The dependency chain is so nuts that
I'm struggling to even review these patches. Good luck to the maintainer
that wants to merge this stuff.

Can't you guys work together a bit more closely so that all of your
patches feel like one logical progression of work?

-- 
Matt Fleming, Intel Open Source Technology Center
