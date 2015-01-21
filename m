Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbbAUSIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:08:19 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:61282 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752024AbbAUSIK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:08:10 -0500
Date: Wed, 21 Jan 2015 10:08:03 -0800
From: Nicolin Chen <nicoleotsuka@gmail.com>
To: Zidan Wang <zidan.wang@freescale.com>
Cc: timur@tabi.org, Xiubo.Lee@gmail.com, lgirdwood@gmail.com,
        broonie@kernel.org, perex@perex.cz, tiwai@suse.de,
        alsa-devel@alsa-project.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel][PATCH 2/3] ASoC: fsl_sai: Add support for tdm slots
 operation
Message-ID: <20150121180801.GA3361@Alpha>
References: <1421756480-7055-1-git-send-email-zidan.wang@freescale.com>
 <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421756480-7055-3-git-send-email-zidan.wang@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 20, 2015 at 08:21:19PM +0800, Zidan Wang wrote:
> @@ -369,10 +380,25 @@ static int fsl_sai_hw_params(struct snd_pcm_substream *substream,
>  	u32 word_width = snd_pcm_format_width(params_format(params));
>  	u32 val_cr4 = 0, val_cr5 = 0;
>  	int ret;
> +	u32 bclk;
> +
> +	if (channels == 1)
> +		channels = 2;
> +
> +	if (!sai->slots || sai->slots % channels)
> +		sai->slots = channels;
> +
> +	sai->slots = sai->slots / channels;
> +
> +	if (sai->slot_width < word_width || sai->is_dsp_mode)
> +		sai->slot_width = word_width;

Could you pls explain a bit what's this overriding for?
Or it might be better to put into a comment.

Nicolin
