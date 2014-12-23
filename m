Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756496AbaLWXGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:06:49 -0500
Received: from mail-ob0-f170.google.com ([209.85.214.170]:59775 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaLWXGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:06:47 -0500
MIME-Version: 1.0
In-Reply-To: <1419325709-15374-3-git-send-email-jay.xu@rock-chips.com>
References: <1419325709-15374-1-git-send-email-jay.xu@rock-chips.com> <1419325709-15374-3-git-send-email-jay.xu@rock-chips.com>
From: Dylan Reid <dgreid@chromium.org>
Date: Tue, 23 Dec 2014 15:06:26 -0800
X-Google-Sender-Auth: XGt6RRr6Glc-RNWKkgv6tT7QCh4
Message-ID: <CAEUnVG79MOHUufRnJVe98ZTC4vouUNAEWtPsryEKWLc+Qpdjuw@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH 2/2] ASoC: rockchip: i2s: set TDL and RDL to
 16 bits
To: Jianqun Xu <jay.xu@rock-chips.com>
Cc: Liam Girdwood <lgirdwood@gmail.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Mark Brown <broonie@kernel.org>, perex@perex.cz,
        Takashi Iwai <tiwai@suse.de>, Sonny Rao <sonnyrao@chromium.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 1:08 AM, Jianqun Xu <jay.xu@rock-chips.com> wrote:
> Set Transmit Data Level(TDL) and Receive Data Level(RDL) to 16 bits.
> Without this setting, the TDL is default to be 0x00 (means 1 bit),
> and the RDL is default to be 0x1f (means 16 bits).

My impression from the TRM was that TDL and RDL were measured in
samples.  Are you sure it's 'bits'?

>
> This patch is helpful to fix pop sound, tested on rk3288 board.
>
> Signed-off-by: Jianqun Xu <jay.xu@rock-chips.com>
> ---
>  sound/soc/rockchip/rockchip_i2s.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/sound/soc/rockchip/rockchip_i2s.c b/sound/soc/rockchip/rockchip_i2s.c
> index c74ba37..1cd7efc 100644
> --- a/sound/soc/rockchip/rockchip_i2s.c
> +++ b/sound/soc/rockchip/rockchip_i2s.c
> @@ -247,6 +247,10 @@ static int rockchip_i2s_hw_params(struct snd_pcm_substream *substream,
>
>         regmap_update_bits(i2s->regmap, I2S_TXCR, I2S_TXCR_VDW_MASK, val);
>         regmap_update_bits(i2s->regmap, I2S_RXCR, I2S_RXCR_VDW_MASK, val);
> +       regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_TDL_MASK,
> +                          I2S_DMACR_TDL(16));
> +       regmap_update_bits(i2s->regmap, I2S_DMACR, I2S_DMACR_RDL_MASK,
> +                          I2S_DMACR_RDL(16));
>
>         return 0;
>  }
> --
> 1.9.1
>
>
> _______________________________________________
> Alsa-devel mailing list
> Alsa-devel@alsa-project.org
> http://mailman.alsa-project.org/mailman/listinfo/alsa-devel
