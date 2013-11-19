Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316Ab3KSOnb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 09:43:31 -0500
Received: from mail-ob0-f181.google.com ([209.85.214.181]:34090 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab3KSOn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 09:43:27 -0500
Date: Tue, 19 Nov 2013 14:43:23 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: sameo@linux.intel.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: wm5110: Add register patch for rev D chip
Message-ID: <20131119144323.GB19953@lee--X1>
References: <1384858219-25347-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1384858219-25347-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think we're lacking of a commit message here.

What does it do? Why do we need it? What would happen if we didn't
have it? Why does it differ between revs? Etc etc ... ?

> Signed-off-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm5110-tables.c |   30 +++++++++++++++++++++++++++++-
>  1 files changed, 29 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/wm5110-tables.c b/drivers/mfd/wm5110-tables.c
> index daf2fe8..bd9c3c9 100644
> --- a/drivers/mfd/wm5110-tables.c
> +++ b/drivers/mfd/wm5110-tables.c
> @@ -223,6 +223,31 @@ static const struct reg_default wm5110_revb_patch[] = {
>  	{ 0x80, 0x0 },
>  };
>  
> +static const struct reg_default wm5110_revd_patch[] = {
> +	{ 0x80, 0x3 },
> +	{ 0x80, 0x3 },
> +	{ 0x393, 0x27 },
> +	{ 0x394, 0x27 },
> +	{ 0x395, 0x27 },
> +	{ 0x396, 0x27 },
> +	{ 0x397, 0x27 },
> +	{ 0x398, 0x26 },
> +	{ 0x221, 0x90 },
> +	{ 0x211, 0x8 },
> +	{ 0x36c, 0x1fb },
> +	{ 0x26e, 0x64 },
> +	{ 0x26f, 0xea },
> +	{ 0x270, 0x1f16 },
> +	{ 0x51b, 0x1 },
> +	{ 0x55b, 0x1 },
> +	{ 0x59b, 0x1 },
> +	{ 0x4f0, 0x633 },
> +	{ 0x441, 0xc059 },
> +	{ 0x209, 0x27 },
> +	{ 0x80, 0x0 },
> +	{ 0x80, 0x0 },
> +};
> +
>  /* We use a function so we can use ARRAY_SIZE() */
>  int wm5110_patch(struct arizona *arizona)
>  {
> @@ -235,7 +260,10 @@ int wm5110_patch(struct arizona *arizona)
>  		return regmap_register_patch(arizona->regmap,
>  					     wm5110_revb_patch,
>  					     ARRAY_SIZE(wm5110_revb_patch));

What happened to rev C?

> -
> +	case 3:

Perhaps we should consider #define'ing these?

> +		return regmap_register_patch(arizona->regmap,
> +					     wm5110_revd_patch,
> +					     ARRAY_SIZE(wm5110_revd_patch));
>  	default:
>  		return 0;
>  	}

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
