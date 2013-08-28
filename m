Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab3H1G23 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 02:28:29 -0400
Received: from top.free-electrons.com ([176.31.233.9]:40285 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754319Ab3H1G22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 02:28:28 -0400
Message-ID: <521D9889.7090109@free-electrons.com>
Date: Wed, 28 Aug 2013 08:28:25 +0200
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC v2 07/16] ARM: mvebu: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1377638890-371-8-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1377638890-371-8-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,
On 27/08/2013 23:28, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks.

You should update the commit log, the .init_time hooks won't be removed
with this patch.

Gregory

> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Changelog:
> v1->v2:
> - only remove of_clk_init from custom timer hook, further cleanup
>   will be carried out later (Reported by Gregory Clement)
> 
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-mvebu/armada-370-xp.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/mach-mvebu/armada-370-xp.c b/arch/arm/mach-mvebu/armada-370-xp.c
> index 829b573..164c62b 100644
> --- a/arch/arm/mach-mvebu/armada-370-xp.c
> +++ b/arch/arm/mach-mvebu/armada-370-xp.c
> @@ -14,7 +14,6 @@
>  
>  #include <linux/kernel.h>
>  #include <linux/init.h>
> -#include <linux/clk-provider.h>
>  #include <linux/of_address.h>
>  #include <linux/of_platform.h>
>  #include <linux/io.h>
> @@ -36,7 +35,6 @@ static void __init armada_370_xp_map_io(void)
>  
>  static void __init armada_370_xp_timer_and_clk_init(void)
>  {
> -	of_clk_init(NULL);
>  	armada_370_xp_timer_init();
>  	coherency_init();
>  	BUG_ON(mvebu_mbus_dt_init());
> 


-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
