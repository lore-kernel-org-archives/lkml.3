Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758872Ab3CESeM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Mar 2013 13:34:12 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:39224 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755343Ab3CESeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Mar 2013 13:34:11 -0500
Message-ID: <51363A9E.6090507@gmail.com>
Date: Tue, 05 Mar 2013 19:34:06 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: Fix typo "COMMON_CLK_DOVE"
References: <1362476098.16460.65.camel@x61.thuisdomein>
In-Reply-To: <1362476098.16460.65.camel@x61.thuisdomein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/05/2013 10:34 AM, Paul Bolle wrote:
> Commit 5b03df9ace680d7cdd34a69dfd85ca5f74159d18 ("ARM: dove: switch to
> DT clock providers") added "select COMMON_CLK_DOVE" to Marvell Dove's
> Kconfig entry. But there's no Kconfig symbol COMMON_CLK_DOVE, which
> makes this select statement a nop. Since the Marvell Dove code includes
> <linux/clk-provider.h>  we can assume that this entry needs to select
> COMMON_CLK instead.
>
> Signed-off-by: Paul Bolle<pebolle@tiscali.nl>
> ---
> Untested.
>
>   arch/arm/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index 5b71469..31acce7 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -556,7 +556,7 @@ config ARCH_IXP4XX
>   config ARCH_DOVE
>   	bool "Marvell Dove"
>   	select ARCH_REQUIRE_GPIOLIB
> -	select COMMON_CLK_DOVE
> +	select COMMON_CLK
>   	select CPU_V7
>   	select GENERIC_CLOCKEVENTS
>   	select MIGHT_HAVE_PCI

Paul,

thanks for the patch but I guess COMMON_CLK_DOVE is a left-over
from early DT experiments with Dove. It should just be removed
from arm/Kconfig.

Thanks for pointing it out, and it would be great to update
your patch accordingly.

Sebastian
