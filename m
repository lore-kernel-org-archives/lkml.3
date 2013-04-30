Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760739Ab3D3OYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 10:24:31 -0400
Received: from smtp-out-087.synserver.de ([212.40.185.87]:1032 "EHLO
	smtp-out-087.synserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760237Ab3D3OY2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 10:24:28 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 30082
Message-ID: <517FD3EC.1050309@metafoo.de>
Date: Tue, 30 Apr 2013 16:23:40 +0200
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Fabio Baltieri <fabio.baltieri@linaro.org>
CC: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lee Jones <lee.jones@linaro.org>,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: Re: [PATCH 2/3] ASoC: ux500: move clock controls to ab8500-codec
References: <1367330994-7259-1-git-send-email-fabio.baltieri@linaro.org> <1367330994-7259-3-git-send-email-fabio.baltieri@linaro.org>
In-Reply-To: <1367330994-7259-3-git-send-email-fabio.baltieri@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/30/2013 04:09 PM, Fabio Baltieri wrote:
> Move ab8500 clock control definitions to the ab8500 codec driver,
> leaving only card specific setting in mop500_ab8500_ctrls.
> 
> Signed-off-by: Fabio Baltieri <fabio.baltieri@linaro.org>
> ---
>  sound/soc/codecs/ab8500-codec.c | 10 ++++++++++
>  sound/soc/ux500/mop500_ab8500.c | 10 ----------
>  2 files changed, 10 insertions(+), 10 deletions(-)
> 
> diff --git a/sound/soc/codecs/ab8500-codec.c b/sound/soc/codecs/ab8500-codec.c
> index a153b16..925e625 100644
> --- a/sound/soc/codecs/ab8500-codec.c
> +++ b/sound/soc/codecs/ab8500-codec.c
> @@ -1615,6 +1615,16 @@ static SOC_ENUM_SINGLE_EXT_DECL(soc_enum_sidstate, enum_sid_state);
>  static SOC_ENUM_SINGLE_EXT_DECL(soc_enum_ancstate, enum_anc_state);
>  
>  static struct snd_kcontrol_new ab8500_ctrls[] = {
> +	/* Digital interface - Clocks */
> +	SOC_SINGLE("Digital Interface Master Generator Switch",
> +		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENMASTGEN,
> +		1, 0),
> +	SOC_SINGLE("Digital Interface 0 Bit-clock Switch",
> +		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK0,
> +		1, 0),
> +	SOC_SINGLE("Digital Interface 1 Bit-clock Switch",
> +		AB8500_DIGIFCONF1, AB8500_DIGIFCONF1_ENFSBITCLK1,
> +		1, 0),

I think this patch as it is is fine. But those three controls looks like
they should be converted to DAPM widgets.

- Lars
