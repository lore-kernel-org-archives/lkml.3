Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756089Ab3EaLiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 07:38:24 -0400
Received: from smtp-out-125.synserver.de ([212.40.185.125]:1054 "EHLO
	smtp-out-122.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756070Ab3EaLhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 07:37:50 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 25770
Message-ID: <51A88B85.5070202@metafoo.de>
Date: Fri, 31 May 2013 13:37:41 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] blackfin: bf533-stamp: Remove bogus "||"
References: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
In-Reply-To: <1369993250-6461-1-git-send-email-geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2013 11:40 AM, Geert Uytterhoeven wrote:
> arch/blackfin/mach-bf533/boards/stamp.c:545:2: error: operator '||' has no right operand
> arch/blackfin/mach-bf533/boards/stamp.c:662:3: error: 'bfin_snd_resources' undeclared here (not in a function)
> arch/blackfin/mach-bf533/boards/stamp.c:662:3: error: negative width in bit-field '<anonymous>'
> arch/blackfin/mach-bf533/boards/stamp.c:665:21: error: 'bfin_snd_data' undeclared here (not in a function)
> make[4]: *** [arch/blackfin/mach-bf533/boards/stamp.o] Error 1
> 
> Introduced by commit 15502e0ca0da651b48c7def2983e7bb464349b2a ("blackfin:
> Remove references to the bf5x_tdm driver"), which removed two config
> options, but only one "||".
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Hm, right I missed that one, thanks.

Acked-by: Lars-Peter Clausen <lars@metafoo.de>

Mark can you queue it up in your topic/blackfin branch?

> ---
> http://kisskb.ellerman.id.au/kisskb/buildresult/8848472/
> 
>  arch/blackfin/mach-bf533/boards/stamp.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/blackfin/mach-bf533/boards/stamp.c b/arch/blackfin/mach-bf533/boards/stamp.c
> index 1ea1dda..4a8c2e3 100644
> --- a/arch/blackfin/mach-bf533/boards/stamp.c
> +++ b/arch/blackfin/mach-bf533/boards/stamp.c
> @@ -542,7 +542,7 @@ static struct platform_device bfin_dpmc = {
>  };
>  
>  #if defined(CONFIG_SND_BF5XX_I2S) || defined(CONFIG_SND_BF5XX_I2S_MODULE) || \
> -	|| defined(CONFIG_SND_BF5XX_AC97) || \
> +	defined(CONFIG_SND_BF5XX_AC97) || \
>  	defined(CONFIG_SND_BF5XX_AC97_MODULE)
>  
>  #include <asm/bfin_sport.h>

