Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759037AbbA0Mf6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 07:35:58 -0500
Received: from mailapp01.imgtec.com ([195.59.15.196]:45649 "EHLO
	mailapp01.imgtec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759011AbbA0Mfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 07:35:54 -0500
Message-ID: <54C78624.5000702@imgtec.com>
Date: Tue, 27 Jan 2015 12:35:48 +0000
From: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: <tiwai@suse.de>, <perex@perex.cz>
CC: <broonie@kernel.org>, <lgirdwood@gmail.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, <lars@metafoo.de>
Subject: Re: [PATCH_V3 4/4] sound: jz4740: set i2s clk rate to 12MHz
References: <1422283993-53642-1-git-send-email-Zubair.Kakakhel@imgtec.com> <1422283993-53642-5-git-send-email-Zubair.Kakakhel@imgtec.com>
In-Reply-To: <1422283993-53642-5-git-send-email-Zubair.Kakakhel@imgtec.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 26/01/15 14:53, Zubair Lutfullah Kakakhel wrote:
> i2s clock rate is not set to 12MHz currently. Set it before enabling
> the clock.
> 
> Signed-off-by: Zubair Lutfullah Kakakhel <Zubair.Kakakhel@imgtec.com>
> 
> ---
> V2 changes: Removed clk_prepare_enable call as clock was already being
> enabled elsewhere. Just set rate to 12MHz.
> ---
>  sound/soc/jz4740/jz4740-i2s.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/sound/soc/jz4740/jz4740-i2s.c b/sound/soc/jz4740/jz4740-i2s.c
> index 07f7781..c2e5852 100644
> --- a/sound/soc/jz4740/jz4740-i2s.c
> +++ b/sound/soc/jz4740/jz4740-i2s.c
> @@ -125,6 +125,7 @@ static int jz4740_i2s_startup(struct snd_pcm_substream *substream,
>  	ctrl |= JZ_AIC_CTRL_FLUSH;
>  	jz4740_i2s_write(i2s, JZ_REG_AIC_CTRL, ctrl);
>  
> +	clk_set_rate(i2s->clk_i2s, 12000000);

Lars recommended using dt and assigned-clock-rates for this. (irc)
I've checked and it can be done.

This patch is not needed.

Patch 1-3 in this series are OK. This last one can be skipped.

Do you want me to repost the series without it? Or is this fine?

Thanks,
ZubairLK

>  	clk_prepare_enable(i2s->clk_i2s);
>  
>  	conf = jz4740_i2s_read(i2s, JZ_REG_AIC_CONF);
> 
