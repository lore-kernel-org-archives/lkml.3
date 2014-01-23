Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528AbaAWKLF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:11:05 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:46427 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaAWKLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:11:03 -0500
MIME-Version: 1.0
In-Reply-To: <1390463283-7545-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390463283-7545-1-git-send-email-Li.Xiubo@freescale.com>
Date: Thu, 23 Jan 2014 08:11:02 -0200
Message-ID: <CAOMZO5ATVkcORZBMbNzu2F-dyJxjzgjkRgezj2vGM9v7cyfy1w@mail.gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: fsl-sai: convert to use regmap API for
 Freeacale SAI
From: Fabio Estevam <festevam@gmail.com>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Timur Tabi <timur@tabi.org>, Nicolin Chen <Guangyu.Chen@freescale.com>,
        Takashi Iwai <tiwai@suse.de>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 23, 2014 at 5:48 AM, Xiubo Li <Li.Xiubo@freescale.com> wrote:

>  static int fsl_sai_set_dai_sysclk(struct snd_soc_dai *cpu_dai,
>                 int clk_id, unsigned int freq, int dir)
>  {
> -       struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
>         int ret;
>
>         if (dir == SND_SOC_CLOCK_IN)
>                 return 0;
>
> -       ret = clk_prepare_enable(sai->clk);
> -       if (ret)
> -               return ret;

The clock related change seems unrelated to the usage of regmap, right?

>  static int fsl_sai_set_dai_fmt(struct snd_soc_dai *cpu_dai, unsigned int fmt)
>  {
> -       struct fsl_sai *sai = snd_soc_dai_get_drvdata(cpu_dai);
>         int ret;
>
> -       ret = clk_prepare_enable(sai->clk);
> -       if (ret)
> -               return ret;

Same here.

Regards,

Fabio Estevam
