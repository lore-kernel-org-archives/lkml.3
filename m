Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbbAZKkF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:40:05 -0500
Received: from smtp-out-156.synserver.de ([212.40.185.156]:1076 "EHLO
	smtp-out-156.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbbAZKkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:40:02 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 16687
Message-ID: <54C61980.9030205@metafoo.de>
Date: Mon, 26 Jan 2015 11:40:00 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.4.0
MIME-Version: 1.0
To: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>, tiwai@suse.de,
        perex@perex.cz
CC: broonie@kernel.org, lgirdwood@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, alsa-devel@alsa-project.org
Subject: Re: [PATCH 4/4] sound: jz4740: Enable codec clock during dai_probe
References: <1422267511-6649-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422267511-6649-5-git-send-email-Zubair.Kakakhel@imgtec.com>
In-Reply-To: <1422267511-6649-5-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2015 11:18 AM, Zubair Lutfullah Kakakhel wrote:
> As we are moving away from platform to DT, we cant rely on the board
> file to do this now. So enable it here.

I don't understand this changelog. The board file never did this. The driver 
enables the clock in the startup() callback.

>
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> ---
>   sound/soc/jz4740/jz4740-i2s.c | 4 ++++
>   1 file changed, 4 insertions(+)
>
> diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
> index 3c309fc..a7e4a7b 100644
> --- a/sound/soc/jz4740/jz4740-i2s.c
> +++ b/sound/soc/jz4740/jz4740-i2s.c
> @@ -376,6 +376,10 @@ static int jz4740_i2s_dai_probe(struct snd_soc_dai *dai)
>   		JZ_AIC_CONF_I2S |
>   		JZ_AIC_CONF_INTERNAL_CODEC;
>
> +	/* enable codec sysclk */
> +	clk_set_rate(i2s->clk_i2s, 12000000);
> +	clk_prepare_enable(i2s->clk_i2s);
> +
>   	jz4740_i2s_write(i2s, JZ_REG_AIC_CONF, JZ_AIC_CONF_RESET);
>   	jz4740_i2s_write(i2s, JZ_REG_AIC_CONF, conf);
>
>

