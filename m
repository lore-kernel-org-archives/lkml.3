Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964935AbaE3RGf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 May 2014 13:06:35 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58656 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933751AbaE3RGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 May 2014 13:06:34 -0400
Message-ID: <5388BA8D.3010707@infradead.org>
Date: Fri, 30 May 2014 10:06:21 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: =?UTF-8?B?TWFudWVsIFNjaMO2bGxpbmc=?= <manuel.schoelling@gmx.de>,
        plagnioj@jcrosoft.com
CC: tomi.valkeinen@ti.com, geert@linux-m68k.org, broonie@linaro.org,
        dh.herrmann@gmail.com, airlied@redhat.com, mtosatti@redhat.com,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] console: Add persistent scrollback buffers for all VGA
 consoles
References: <1401456425-15931-1-git-send-email-manuel.schoelling@gmx.de>
In-Reply-To: <1401456425-15931-1-git-send-email-manuel.schoelling@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 06:27 AM, Manuel Schölling wrote:
> ---
>  drivers/video/console/Kconfig  |    6 +-
>  drivers/video/console/vgacon.c |  124 ++++++++++++++++++++++++----------------
>  2 files changed, 79 insertions(+), 51 deletions(-)
> 
> diff --git a/drivers/video/console/Kconfig b/drivers/video/console/Kconfig
> index fe1cd01..d7ec96c 100644
> --- a/drivers/video/console/Kconfig
> +++ b/drivers/video/console/Kconfig
> @@ -38,14 +38,14 @@ config VGACON_SOFT_SCROLLBACK
>  	 RAM to allocate for this buffer.  If unsure, say 'N'.
>  
>  config VGACON_SOFT_SCROLLBACK_SIZE
> -       int "Scrollback Buffer Size (in KB)"
> +       int "Scrollback Buffer Size per console (in KB)"
>         depends on VGACON_SOFT_SCROLLBACK
>         range 1 1024
>         default "64"
>         help
>           Enter the amount of System RAM to allocate for the scrollback
> -	 buffer.  Each 64KB will give you approximately 16 80x25
> -	 screenfuls of scrollback buffer
> +	 buffer for each VGA console. Each 64KB will give you approximately
> +	 16 80x25 screenfuls of scrollback buffer.

Nitpick: CodingStyle says to indent help text 1 tab + 2 spaces.

>  
>  config MDA_CONSOLE
>  	depends on !M68K && !PARISC && ISA

-- 
~Randy
