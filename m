Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbaFXHsm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 03:48:42 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:52476 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751257AbaFXHsl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 03:48:41 -0400
Message-ID: <53A92D49.9060306@ti.com>
Date: Tue, 24 Jun 2014 10:48:25 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, <linux-kernel@vger.kernel.org>
CC: Jarkko Nikula <jarkko.nikula@bitmer.com>, <linux-omap@vger.kernel.org>
Subject: Re: [PATCH 1/1] sound/soc/omap/mcbsp.c: remove unnecessary null test
 before kfree
References: <1403541221-10619-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1403541221-10619-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fabian,

On 06/23/2014 07:33 PM, Fabian Frederick wrote:
> Fix checkpatch warning:
> WARNING: kfree(NULL) is safe this check is probably not required

can you send the same patch to alsa-devel with subject:
ASoC: mcbsp:  remove unnecessary null test before kfree

You can add my:
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

> 
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
> Cc: linux-omap@vger.kernel.org
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  sound/soc/omap/mcbsp.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/sound/soc/omap/mcbsp.c b/sound/soc/omap/mcbsp.c
> index 86c7538..68a1252 100644
> --- a/sound/soc/omap/mcbsp.c
> +++ b/sound/soc/omap/mcbsp.c
> @@ -621,8 +621,7 @@ void omap_mcbsp_free(struct omap_mcbsp *mcbsp)
>  	mcbsp->reg_cache = NULL;
>  	spin_unlock(&mcbsp->lock);
>  
> -	if (reg_cache)
> -		kfree(reg_cache);
> +	kfree(reg_cache);
>  }
>  
>  /*
> 


-- 
Péter
