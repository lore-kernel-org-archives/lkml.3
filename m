Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755093Ab3H2QdG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:33:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:58110 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753060Ab3H2QdE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:33:04 -0400
Date: Thu, 29 Aug 2013 09:33:00 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mischa Jonker <Mischa.Jonker@synopsys.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] input/serio: disable i8042 PC keyboard ctrl for ARC
Message-ID: <20130829163259.GC1576@core.coreip.homeip.net>
References: <1377715616-2548-1-git-send-email-mjonker@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377715616-2548-1-git-send-email-mjonker@synopsys.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 08:46:56PM +0200, Mischa Jonker wrote:
> It causes crashes when enabled, and we don't have such a peripheral
> anyway on ARC platforms.
> 
> Signed-off-by: Mischa Jonker <mjonker@synopsys.com>
> ---
>  drivers/input/serio/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/input/serio/Kconfig b/drivers/input/serio/Kconfig
> index 94c17c2..1e691a3 100644
> --- a/drivers/input/serio/Kconfig
> +++ b/drivers/input/serio/Kconfig
> @@ -22,7 +22,8 @@ config SERIO_I8042
>  	tristate "i8042 PC Keyboard controller" if EXPERT || !X86
>  	default y
>  	depends on !PARISC && (!ARM || ARCH_SHARK || FOOTBRIDGE_HOST) && \
> -		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390
> +		   (!SUPERH || SH_CAYMAN) && !M68K && !BLACKFIN && !S390 && \
> +		   !ARC
>  	help
>  	  i8042 is the chip over which the standard AT keyboard and PS/2
>  	  mouse are connected to the computer. If you use these devices,


Applied, thank you.

-- 
Dmitry
