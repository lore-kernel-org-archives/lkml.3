Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab3FYVlL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 17:41:11 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:40960 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3FYVlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 17:41:10 -0400
MIME-Version: 1.0
In-Reply-To: <201306192016.00659.arnd@arndb.de>
References: <1370519244-49918-1-git-send-email-holt@sgi.com>
	<12642293.RmlRtOVM54@wuerfel>
	<20130619102141.411c8e39.akpm@linux-foundation.org>
	<201306192016.00659.arnd@arndb.de>
Date: Tue, 25 Jun 2013 14:41:08 -0700
Message-ID: <CAGa+x87SZyOU3SWcBEUGKzke8whbHhudRzsj0VjgGU_VkhnJZA@mail.gmail.com>
Subject: Re: [PATCH -v11 resend 10/11] arm, change reboot_mode to use enum reboot_mode
From: Kevin Hilman <khilman@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Robin Holt <holt@sgi.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Russ Anderson <rja@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 19, 2013 at 11:16 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 19 June 2013, Andrew Morton wrote:
>> This patchset gets a lot of rejects which I keep on fixing up.  Please
>> merge up early in the merge window and compile-test (and review) the
>> linux-next changes to make sure I didn't muck up the reject-fixing,
>> then we should be fine.
>
> Ok, good. The patch below is what I used locally to get everything to
> build. Please fold that into the larger patch.

I'm still seeing build breaks in linux-next due to the original patch.

Will the fix below from Arnd be folded into the original?

Kevin

> From cc87f1a209e88d007f93c5c52813d523b753657b Mon Sep 17 00:00:00 2001
> From: Arnd Bergmann <arnd@arndb.de>
> Date: Wed, 19 Jun 2013 12:54:48 +0200
> Subject: [PATCH] ARM: use enum reboot_type on new platforms
>
> The interface has changed with "reboot: arm: change reboot_mode to
> use enum reboot_mode" that is getting merged through the -mm tree.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> diff --git a/arch/arm/mach-keystone/keystone.c b/arch/arm/mach-keystone/keystone.c
> index fe4d9ff..7c1bbe2e 100644
> --- a/arch/arm/mach-keystone/keystone.c
> +++ b/arch/arm/mach-keystone/keystone.c
> @@ -14,6 +14,7 @@
>  #include <linux/init.h>
>  #include <linux/of_platform.h>
>  #include <linux/of_address.h>
> +#include <linux/reboot.h>
>
>  #include <asm/setup.h>
>  #include <asm/mach/map.h>
> @@ -49,7 +50,7 @@ static const char *keystone_match[] __initconst = {
>         NULL,
>  };
>
> -void keystone_restart(char mode, const char *cmd)
> +void keystone_restart(enum reboot_mode mode, const char *cmd)
>  {
>         u32 val;
>
> diff --git a/arch/arm/mach-omap2/omap4-restart.c b/arch/arm/mach-omap2/omap4-restart.c
> index 652adde..41dfd7d 100644
> --- a/arch/arm/mach-omap2/omap4-restart.c
> +++ b/arch/arm/mach-omap2/omap4-restart.c
> @@ -8,6 +8,7 @@
>   */
>
>  #include <linux/types.h>
> +#include <linux/reboot.h>
>  #include "prminst44xx.h"
>
>  /**
> diff --git a/arch/arm/mach-zynq/common.c b/arch/arm/mach-zynq/common.c
> index ef5b84f..c2c9083 100644
> --- a/arch/arm/mach-zynq/common.c
> +++ b/arch/arm/mach-zynq/common.c
> @@ -26,6 +26,7 @@
>  #include <linux/of_platform.h>
>  #include <linux/of.h>
>  #include <linux/irqchip.h>
> +#include <linux/reboot.h>
>
>  #include <asm/mach/arch.h>
>  #include <asm/mach/map.h>
> @@ -92,7 +93,7 @@ static void __init zynq_map_io(void)
>         zynq_scu_map_io();
>  }
>
> -static void zynq_system_reset(char mode, const char *cmd)
> +static void zynq_system_reset(enum reboot_mode mode, const char *cmd)
>  {
>         zynq_slcr_system_reset();
>  }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
