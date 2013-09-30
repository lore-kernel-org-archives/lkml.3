Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab3I3Wnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 18:43:47 -0400
Received: from outbound-mail03.westnet.com.au ([203.10.1.244]:32949 "EHLO
	outbound-mail03.westnet.com.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754789Ab3I3Wnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 18:43:46 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMBAJP9SVI6B/5Q/2dsb2JhbAANTMUOgUiDGQEBAQQ4QAEQCw4KCRYPCQMCAQIBRQYNAQUCAQGyOJM4j1EHhCIDojiKdg
X-IronPort-AV: E=Sophos;i="4.90,1010,1371052800"; 
   d="scan'208";a="361321520"
X-WN-REMOTEIP: 58.7.254.80
X-WN-ENVELOPESENDER: gerg@uclinux.org
X-WN-MID: 361321520
X-WN-SMTPAUTHID: gregungerer@westnet.com.au
Message-ID: <5249FE9C.2000208@uclinux.org>
Date: Tue, 01 Oct 2013 08:43:40 +1000
From: Greg Ungerer <gerg@uclinux.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH] ARM: ks8695: fix incorrect placement of __initdata tag
References: <1551134.v305P4LSfh@amdc1032>
In-Reply-To: <1551134.v305P4LSfh@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/09/13 23:02, Bartlomiej Zolnierkiewicz wrote:
> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.
>
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
>   arch/arm/mach-ks8695/board-og.c | 2 +-
>   arch/arm/mach-ks8695/cpu.c      | 3 +--
>   2 files changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/arch/arm/mach-ks8695/board-og.c b/arch/arm/mach-ks8695/board-og.c
> index 002bc61..9204f5a 100644
> --- a/arch/arm/mach-ks8695/board-og.c
> +++ b/arch/arm/mach-ks8695/board-og.c
> @@ -79,7 +79,7 @@ static void __init og_pci_bus_reset(void)
>   #define	S8250_VIRT	0xf4000000
>   #define	S8250_SIZE	0x00100000
>
> -static struct __initdata map_desc og_io_desc[] = {
> +static struct map_desc og_io_desc[] __initdata = {
>   	{
>   		.virtual	= S8250_VIRT,
>   		.pfn		= __phys_to_pfn(S8250_PHYS),
> diff --git a/arch/arm/mach-ks8695/cpu.c b/arch/arm/mach-ks8695/cpu.c
> index ddb2422..9618654 100644
> --- a/arch/arm/mach-ks8695/cpu.c
> +++ b/arch/arm/mach-ks8695/cpu.c
> @@ -33,8 +33,7 @@
>   #include <mach/regs-sys.h>
>   #include <mach/regs-misc.h>
>
> -
> -static struct __initdata map_desc ks8695_io_desc[] = {
> +static struct map_desc ks8695_io_desc[] __initdata = {
>   	{
>   		.virtual	= (unsigned long)KS8695_IO_VA,
>   		.pfn		= __phys_to_pfn(KS8695_IO_PA),
>

