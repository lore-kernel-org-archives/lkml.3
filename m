Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115AbaCDJut (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:50:49 -0500
Received: from smtp-out-147.synserver.de ([212.40.185.147]:1087 "EHLO
	smtp-out-014.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756613AbaCDJun (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:50:43 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 12559
Message-ID: <5315A203.2060103@metafoo.de>
Date: Tue, 04 Mar 2014 10:50:59 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Xiubo Li <Li.Xiubo@freescale.com>
CC: broonie@kernel.org, lgirdwood@gmail.com, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [alsa-devel] [RFC][PATCH 1/3] ASoC: core: Move the default regmap
 I/O setting to snd_soc_register_codec()
References: <1393921529-28985-1-git-send-email-Li.Xiubo@freescale.com> <1393921529-28985-2-git-send-email-Li.Xiubo@freescale.com>
In-Reply-To: <1393921529-28985-2-git-send-email-Li.Xiubo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 09:25 AM, Xiubo Li wrote:
> Add the default regmap I/O setting to snd_soc_register_codec() while
> the CODEC is initialising, which will be called by CODEC driver device
> probe(), and then we can make set_cache_io() go away entirely from each
> CODEC ASoC probe.
>
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>   include/sound/soc.h  |  3 +++
>   sound/soc/soc-core.c | 11 +++++++++++
>   2 files changed, 14 insertions(+)
>
> diff --git a/include/sound/soc.h b/include/sound/soc.h
> index 4c4d7e1..94bc1c4 100644
> --- a/include/sound/soc.h
> +++ b/include/sound/soc.h
> @@ -749,6 +749,9 @@ struct snd_soc_codec_driver {
>   	int (*set_pll)(struct snd_soc_codec *codec, int pll_id, int source,
>   		unsigned int freq_in, unsigned int freq_out);
>
> +	/* codec regmap */
> +	struct regmap *regmap;
> +

Nope. The driver struct is globally shared between all device instances, the 
regmap struct is device instance specific. The proper way to solve this is 
to have a function like snd_soc_register_codec_with_io() which takes a 
pointer to the regmap struct.
