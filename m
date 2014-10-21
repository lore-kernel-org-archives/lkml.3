Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932465AbaJUMj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:39:27 -0400
Received: from smtp-out-023.synserver.de ([212.40.185.23]:1103 "EHLO
	smtp-out-021.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932170AbaJUMj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:39:26 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 32412
Message-ID: <544653ED.8000304@metafoo.de>
Date: Tue, 21 Oct 2014 14:39:09 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.8.1
MIME-Version: 1.0
To: Jianqun <jay.xu@rock-chips.com>, heiko@sntech.de, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        alsa-devel@alsa-project.org
CC: huangtao@rock-chips.com, cf@rock-chips.com
Subject: Re: [alsa-devel] [PATCH] ASoC: rockchip-i2s: add rockchip-max98090
 driver support
References: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
In-Reply-To: <1413891110-21059-1-git-send-email-jay.xu@rock-chips.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 01:31 PM, Jianqun wrote:
> This patch is to add support for rockchip board with max98090 codec.
> It also needs sound node in dt file.
>
> Tested on rockchip board based on rk3288.
>
> Signed-off-by: Jianqun <jay.xu@rock-chips.com>
> ---
>   sound/soc/rockchip/Kconfig | 13 +++++++++++++
>   1 file changed, 13 insertions(+)
>
> diff --git a/sound/soc/rockchip/Kconfig b/sound/soc/rockchip/Kconfig
> index 78fc159..482cbba 100644
> --- a/sound/soc/rockchip/Kconfig
> +++ b/sound/soc/rockchip/Kconfig
> @@ -9,3 +9,16 @@ config SND_SOC_ROCKCHIP
>
>   config SND_SOC_ROCKCHIP_I2S
>   	tristate
> +	depends on CLKDEV_LOOKUP && SND_SOC_ROCKCHIP
> +	help
> +	  Say Y or M if you want to add support for I2S driver for Rockchip
> +	  I2S device.
> +
> +config SND_SOC_ROCKCHIP_MAX98090
> +	tristate "ASoC support Rockchip board with max98090"
> +	depends on I2C && GPIOLIB
> +	select SND_SOC_ROCKCHIP_I2S
> +	select SND_SOC_MAX98090
> +	help
> +	  Say Y or M here if you want to add support for Rockchio board using
> +	  a max98090 codec.
>

Just make the max98090 driver directly selectable. That's what we typically 
do for DT based designs.

- Lars
