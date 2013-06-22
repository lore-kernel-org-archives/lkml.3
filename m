Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423506Ab3FVAfU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 20:35:20 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:46351 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161521Ab3FVAfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 20:35:18 -0400
Date: Fri, 21 Jun 2013 17:35:11 -0700
From: Anton Vorontsov <anton@enomsg.org>
To: Pawel Moll <pawel.moll@arm.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] power/reset: Make the vexpress driver optional on arm
 and arm64
Message-ID: <20130622003510.GA32416@lizard.mcd26095.sjc.wayport.net>
References: <1370877121-26211-1-git-send-email-pawel.moll@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370877121-26211-1-git-send-email-pawel.moll@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 04:12:01PM +0100, Pawel Moll wrote:
> The driver can be used on either arm or arm64 platforms, but
> the latter doesn't have any platform-specific configuration
> options, so it must be possible to manually enable the driver.
> 
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>
> Acked-by: Catalin Marinas <catalin.marinas@arm.com>
> ---

Applied. Thanks a lot, Pawel!

> diff --git a/drivers/power/reset/Kconfig b/drivers/power/reset/Kconfig
> index 349e9ae..ee039dc 100644
> --- a/drivers/power/reset/Kconfig
> +++ b/drivers/power/reset/Kconfig
> @@ -32,7 +32,8 @@ config POWER_RESET_RESTART
>  	  user presses a key. u-boot then boots into Linux.
>  
>  config POWER_RESET_VEXPRESS
> -	bool
> +	bool "ARM Versatile Express power-off and reset driver"
> +	depends on ARM || ARM64
>  	depends on POWER_RESET
>  	help
>  	  Power off and reset support for the ARM Ltd. Versatile
> -- 
> 1.8.1.2
