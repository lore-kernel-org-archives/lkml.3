Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759411Ab3BMA3w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 19:29:52 -0500
Received: from cassarossa.samfundet.no ([193.35.52.29]:46388 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753230Ab3BMA3v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 19:29:51 -0500
X-Greylist: delayed 2426 seconds by postgrey-1.27 at vger.kernel.org; Tue, 12 Feb 2013 19:29:51 EST
Date: Wed, 13 Feb 2013 00:49:21 +0100
From: Hans-Christian Egtvedt <egtvedt@samfundet.no>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] avr32: atmel_default_console_device depends on
 CONFIG_SERIAL_ATMEL
Message-ID: <20130212234921.GA11388@samfundet.no>
References: <1360679255-11799-1-git-send-email-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1360679255-11799-1-git-send-email-geert@linux-m68k.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Around Tue 12 Feb 2013 15:27:35 +0100 or thereabout, Geert Uytterhoeven wrote:
> allnoconfig:
> 
> arch/avr32/mach-at32ap/built-in.o: In function `at32_select_gpio':
> (.init.text+0x548): undefined reference to `atmel_default_console_device'

Indeed, I guess building without serial support has never been done.

> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
>

Acked-by: Hans-Christian Egtvedt <egtvedt@samfundet.no>

> ---
>  arch/avr32/mach-at32ap/at32ap700x.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/avr32/mach-at32ap/at32ap700x.c b/arch/avr32/mach-at32ap/at32ap700x.c
> index b323d8d..a2fe61b 100644
> --- a/arch/avr32/mach-at32ap/at32ap700x.c
> +++ b/arch/avr32/mach-at32ap/at32ap700x.c
> @@ -1060,7 +1060,9 @@ struct platform_device *__init at32_add_device_usart(unsigned int id)
>  
>  void __init at32_setup_serial_console(unsigned int usart_id)
>  {
> +#ifdef CONFIG_SERIAL_ATMEL
>  	atmel_default_console_device = at32_usarts[usart_id];
> +#endif
>  }
>  
>  /* --------------------------------------------------------------------
-- 
mvh
Hans-Christian Egtvedt
