Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758848Ab3B0XWP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 18:22:15 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:37742 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751991Ab3B0XWO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 18:22:14 -0500
Date: Wed, 27 Feb 2013 15:18:26 -0800
From: Anton Vorontsov <anton@enomsg.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH] power: make goldfish option have a dependency on goldfish
Message-ID: <20130227231826.GA30154@lizard.fhda.edu>
References: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1361989666-1922-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Paul,

On Wed, Feb 27, 2013 at 01:27:46PM -0500, Paul Gortmaker wrote:
> Nearly all the other goldfish peripherals (mtd, keyboard, etc)
> have a dependency on the main platform's GOLDFISH Kconfig item,
> but this one got skipped, so add it.
> 
> Cc: Anton Vorontsov <cbou@mail.ru>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---

Our policy, IIRC, has been quite the opposite: we try to put as little
dependencies as possible, letting drivers build on all different kinds of
configs/arches/machines. Why? It helps us keep the code in a good shape.

So, unless there are any unresolable build issues with the driver, I
believe we should keep it as is.

Thanks,

Anton

>  drivers/power/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/power/Kconfig b/drivers/power/Kconfig
> index 9e00c38..d314528 100644
> --- a/drivers/power/Kconfig
> +++ b/drivers/power/Kconfig
> @@ -348,7 +348,7 @@ config AB8500_BM
>  
>  config BATTERY_GOLDFISH
>  	tristate "Goldfish battery driver"
> -	depends on GENERIC_HARDIRQS
> +	depends on GENERIC_HARDIRQS && GOLDFISH
>  	help
>  	  Say Y to enable support for the battery and AC power in the
>  	  Goldfish emulator.
> -- 
> 1.8.1.2
