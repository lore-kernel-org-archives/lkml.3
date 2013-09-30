Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab3I3Sa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 14:30:59 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:53647 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab3I3Sa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:30:58 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH v2] ARM: shmobile: ape6evm: fix incorrect placement of __initdata tag
Date: Mon, 30 Sep 2013 20:31:05 +0200
Message-ID: <27072275.6rIbiFzHY2@avalon>
User-Agent: KMail/4.10.5 (Linux/3.8.13-gentoo; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1959578.PFsrHiTtYY@amdc1032>
References: <1959578.PFsrHiTtYY@amdc1032>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 30 September 2013 17:34:36 Bartlomiej Zolnierkiewicz wrote:
> __initdata tag should be placed between the variable name and equal
> sign for the variable to be placed in the intended .init.data section.
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

> ---
> v2:
> - use __initdata as it is OK to do it
> 
>  arch/arm/mach-shmobile/board-ape6evm.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm/mach-shmobile/board-ape6evm.c
> b/arch/arm/mach-shmobile/board-ape6evm.c index 7627385..8954f55 100644
> --- a/arch/arm/mach-shmobile/board-ape6evm.c
> +++ b/arch/arm/mach-shmobile/board-ape6evm.c
> @@ -86,7 +86,7 @@ static struct gpio_keys_button gpio_buttons[] = {
>  	GPIO_KEY(KEY_VOLUMEDOWN,	329,	"S21"),
>  };
> 
> -static struct __initdata gpio_keys_platform_data ape6evm_keys_pdata = {
> +static struct gpio_keys_platform_data ape6evm_keys_pdata __initdata = {
>  	.buttons	= gpio_buttons,
>  	.nbuttons	= ARRAY_SIZE(gpio_buttons),
>  };
-- 
Regards,

Laurent Pinchart

