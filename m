Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033AbbAMJrM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 04:47:12 -0500
Received: from smtp-out-212.synserver.de ([212.40.185.212]:1056 "EHLO
	smtp-out-210.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751257AbbAMJrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 04:47:10 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 5625
Message-ID: <54B4E996.80403@metafoo.de>
Date: Tue, 13 Jan 2015 10:47:02 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Bo Shen <voice.shen@atmel.com>, Mark Brown <broonie@kernel.org>
CC: ckeepax@opensource.wolfsonmicro.com, alsa-devel@alsa-project.org,
        linux-sound@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ASoC: wm8904: fix runtime warning
References: <1421141643-30105-1-git-send-email-voice.shen@atmel.com>
In-Reply-To: <1421141643-30105-1-git-send-email-voice.shen@atmel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2015 10:34 AM, Bo Shen wrote:
[...]
>
> -	{ "AIFOUTL", "Left",  "ADCL" },
> -	{ "AIFOUTL", "Right", "ADCR" },
> -	{ "AIFOUTR", "Left",  "ADCL" },
> -	{ "AIFOUTR", "Right", "ADCR" },
> +	{ "AIFOUTL Mux", "Left", "ADCL" },
> +	{ "AIFOUTL Mux", "Right", "ADCR" },
> +	{ "AIFOUTR Mux", "Left", "ADCL" },
> +	{ "AIFOUTR Mux", "Right", "ADCR" },
> +
> +	{ "AIFOUTL", NULL, "AIFOUTL Mux" },
> +	{ "AIFOUTR", NULL, "AIFOUTR Mux" },
>

This looks ok.

>   	{ "ADCL", NULL, "CLK_DSP" },
>   	{ "ADCL", NULL, "Left Capture PGA" },
> @@ -1089,14 +1092,20 @@ static const struct snd_soc_dapm_route adc_intercon[] = {
>   };
>
>   static const struct snd_soc_dapm_route dac_intercon[] = {
> -	{ "DACL", "Right", "AIFINR" },
> -	{ "DACL", "Left",  "AIFINL" },
> +	{ "DACL", NULL, "AIFINL" },
> +	{ "DACL", NULL, "AIFINR" },
>   	{ "DACL", NULL, "CLK_DSP" },
>
> -	{ "DACR", "Right", "AIFINR" },
> -	{ "DACR", "Left",  "AIFINL" },
> +	{ "DACR", NULL, "AIFINL" },
> +	{ "DACR", NULL, "AIFINR" },
>   	{ "DACR", NULL, "CLK_DSP" },
>
> +	{ "DACL Mux", "Left", "DACL" },
> +	{ "DACL Mux", "Right", "DACR" },
> +
> +	{ "DACR Mux", "Left", "DACL" },
> +	{ "DACR Mux", "Right", "DACR" },
> +

But this should probably be

 > +	{ "DACL Mux", "Left", "AIFINL" },
 > +	{ "DACL Mux", "Right", "AIFINR" },
 > +
 > +	{ "DACR Mux", "Left", "AIFINL" },
 > +	{ "DACR Mux", "Right", "AIFINR" },
 > +
 > +	{ "DACL", NULL, "DACL Mux" },
 > +	{ "DACR", NULL, "DACR Mux" },


