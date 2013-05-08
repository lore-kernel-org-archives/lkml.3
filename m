Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752434Ab3EHIFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 04:05:00 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:55646 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab3EHIE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 04:04:56 -0400
Date: Wed, 8 May 2013 09:04:48 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Fabio Baltieri <fabio.baltieri@linaro.org>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 2/6] ASoC: ux500: Do not clear state if already idle
Message-ID: <20130508080448.GG3102@gmail.com>
References: <1367997261-32048-1-git-send-email-fabio.baltieri@linaro.org>
 <1367997261-32048-3-git-send-email-fabio.baltieri@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1367997261-32048-3-git-send-email-fabio.baltieri@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 08 May 2013, Fabio Baltieri wrote:

> As enable_msp gets called only after some audio data has been received,
> if the userspace closes the device before sending any data it causes
> ux500_msp_i2s_close to clear device state even if it was not previously
> initialized.
> 
> This in turns leads to some non necessary but harmless writel, but also
   Singular ^

> to decrementing the pinctrl usage counter (pinctrl_rxtx_ref) below zero.
> 
> To prevent this from happening add a condition to skip register and
> pinctrl clear if current msp state is already MSP_STATE_IDLE.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  sound/soc/ux500/ux500_msp_i2s.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/ux500/ux500_msp_i2s.c b/sound/soc/ux500/ux500_msp_i2s.c
> index a26c6bf..964cfd6 100644
> --- a/sound/soc/ux500/ux500_msp_i2s.c
> +++ b/sound/soc/ux500/ux500_msp_i2s.c
> @@ -638,7 +638,7 @@ int ux500_msp_i2s_close(struct ux500_msp *msp, unsigned int dir)
>  	dev_dbg(msp->dev, "%s: Enter (dir = 0x%01x).\n", __func__, dir);
>  
>  	status = disable_msp(msp, dir);
> -	if (msp->dir_busy == 0) {
> +	if (msp->dir_busy == 0 && msp->msp_state != MSP_STATE_IDLE) {
>  		/* disable sample rate and frame generators */
>  		msp->msp_state = MSP_STATE_IDLE;
>  		writel((readl(msp->registers + MSP_GCR) &

Code looks good though:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
