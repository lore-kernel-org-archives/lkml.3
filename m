Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753193Ab3HVL7H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 07:59:07 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:57688 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab3HVL7F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 07:59:05 -0400
MIME-Version: 1.0
In-Reply-To: <1374361656-3034-1-git-send-email-andrea.adami@gmail.com>
References: <1374361656-3034-1-git-send-email-andrea.adami@gmail.com>
Date: Thu, 22 Aug 2013 13:59:00 +0200
Message-ID: <CAAQYJAuq9kyGL3PWuDGfs9T9Fn1ed03NKgT3CsawWbZeTW8F3g@mail.gmail.com>
Subject: Re: [PATCH] sa1100: collie: fall back to jedec_probe flash detection
From: Andrea Adami <andrea.adami@gmail.com>
To: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Cc: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BUMP

At the moment cfi will not detect the collie NOR.
In the meanwhile we can revert to the jedec-probe map which has been
fixed with following commit:

mtd: jedec_probe: fix LH28F640BF definition
fe2f4c8e0bf2756b670ee78fa9772613a2ea8495

Somehow this is unsatisfactory because the flash is mounted READ ONLY
(as from factory, with a RO cramfs).
Further debugging of cfi detection and vpp is needed.

Andrea


On Sun, Jul 21, 2013 at 1:07 AM, Andrea Adami <andrea.adami@gmail.com> wrote:
> Zaurus 5500 contains 2 LH28F640BFHE-PTTL90 (64M 4Mx16) and
> the LH28F640BFHE-PTTL90.pdf datasheet available on the net shows
> the exact erasesize and the OTP support.
> At the moment only jedec_probe can discover the chip and
> the NOR is mounted read only probably because of wrong vpp.
>
> Signed-off-by: Andrea Adami <andrea.adami@gmail.com>
> ---
>  arch/arm/mach-sa1100/collie.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/mach-sa1100/collie.c b/arch/arm/mach-sa1100/collie.c
> index 612a456..7fb96eb 100644
> --- a/arch/arm/mach-sa1100/collie.c
> +++ b/arch/arm/mach-sa1100/collie.c
> @@ -289,7 +289,7 @@ static void collie_flash_exit(void)
>  }
>
>  static struct flash_platform_data collie_flash_data = {
> -       .map_name       = "cfi_probe",
> +       .map_name       = "jedec_probe",
>         .init           = collie_flash_init,
>         .set_vpp        = collie_set_vpp,
>         .exit           = collie_flash_exit,
> --
> 1.8.1.5
>
