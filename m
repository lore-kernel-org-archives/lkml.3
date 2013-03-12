Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab3CLNkg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:40:36 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:36601 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753102Ab3CLNkf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:40:35 -0400
Message-ID: <513F304D.4090405@gmail.com>
Date: Tue, 12 Mar 2013 14:40:29 +0100
From: Daniel Mack <zonque@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130219 Thunderbird/17.0.3
MIME-Version: 1.0
To: Wei Yongjun <weiyj.lk@gmail.com>
CC: lgirdwood@gmail.com, broonie@opensource.wolfsonmicro.com, perex@perex.cz,
        tiwai@suse.de, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yongjun_wei@trendmicro.com.cn, alsa-devel@alsa-project.org,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] ASoC: tas5086: use module_i2c_driver to simplify
 the code
References: <CAPgLHd_J+xdx6UdSFahEGmPJX-SXEkQBL7xHA7MEGKf21=32Uw@mail.gmail.com>
In-Reply-To: <CAPgLHd_J+xdx6UdSFahEGmPJX-SXEkQBL7xHA7MEGKf21=32Uw@mail.gmail.com>
X-Enigmail-Version: undefined
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.03.2013 14:36, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Use the module_i2c_driver() macro to make the code smaller
> and a bit simpler.

Thanks for catching this!

> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>

Acked-by: Daniel Mack <zonque@gmail.com>



> ---
>  sound/soc/codecs/tas5086.c | 12 +-----------
>  1 file changed, 1 insertion(+), 11 deletions(-)
> 
> diff --git a/sound/soc/codecs/tas5086.c b/sound/soc/codecs/tas5086.c
> index 008bea4..40cee84 100644
> --- a/sound/soc/codecs/tas5086.c
> +++ b/sound/soc/codecs/tas5086.c
> @@ -584,17 +584,7 @@ static struct i2c_driver tas5086_i2c_driver = {
>  	.remove		= tas5086_i2c_remove,
>  };
>  
> -static int __init tas5086_modinit(void)
> -{
> -	return i2c_add_driver(&tas5086_i2c_driver);
> -}
> -module_init(tas5086_modinit);
> -
> -static void __exit tas5086_modexit(void)
> -{
> -	i2c_del_driver(&tas5086_i2c_driver);
> -}
> -module_exit(tas5086_modexit);
> +module_i2c_driver(tas5086_i2c_driver);
>  
>  MODULE_AUTHOR("Daniel Mack <zonque@gmail.com>");
>  MODULE_DESCRIPTION("Texas Instruments TAS5086 ALSA SoC Codec Driver");
> 
> 

