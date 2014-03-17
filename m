Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509AbaCQJ35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 05:29:57 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:35782 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932396AbaCQJ34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 05:29:56 -0400
Message-ID: <5326C086.6080609@ti.com>
Date: Mon, 17 Mar 2014 11:29:42 +0200
From: Jyri Sarha <jsarha@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Jean-Francois Moine <moinejf@free.fr>, Mark Brown <broonie@kernel.org>
CC: <alsa-devel@alsa-project.org>, Xiubo Li <Li.Xiubo@freescale.com>,
        <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v3 2/4] ASoC: simple-card: dynamically allocate
 the DAI link and properties
References: <cover.1394883134.git.moinejf@free.fr> <1cf50fea2306bcb05987533042dbf1495b2c6f07.1394883134.git.moinejf@free.fr>
In-Reply-To: <1cf50fea2306bcb05987533042dbf1495b2c6f07.1394883134.git.moinejf@free.fr>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2014 01:09 PM, Jean-Francois Moine wrote:
> The DAI link array and the properties (fmt, sysclk slots) are
> hard-coded for a single CPU / CODEC link.
>
> This patch dynamically allocates the DAI link array and the
> properties with the aim of supporting many DAI links.
>
> Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> ---
>   sound/soc/generic/simple-card.c | 49 +++++++++++++++++++++++++----------------
>   1 file changed, 30 insertions(+), 19 deletions(-)
>
> diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> index ca7e63e..a55dc46 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
> @@ -20,9 +20,11 @@
>
>   struct simple_card_data {
>   	struct snd_soc_card snd_card;
> -	struct asoc_simple_dai cpu_dai;
> -	struct asoc_simple_dai codec_dai;
> -	struct snd_soc_dai_link snd_link;
> +	struct simple_dais {
> +		struct asoc_simple_dai cpu_dai;
> +		struct asoc_simple_dai codec_dai;
> +	} *dais;
> +	struct snd_soc_dai_link dai_link[];	/* dynamically allocated */
>   };
>

This is only an implementation detail, but wouldn't it produce a cleaner 
implementation if you would write the above structure like this:

   struct simple_card_data {
   	struct snd_soc_card snd_card;
	struct simple_dai_links {
		struct snd_soc_dai_link dai_link;
		struct asoc_simple_dai cpu_dai;
		struct asoc_simple_dai codec_dai;
	} *dai_links;
   };

or even

   struct simple_card_data {
   	struct snd_soc_card snd_card;
	struct simple_dai_links {
		struct snd_soc_dai_link dai_link;
		struct asoc_simple_dai cpu_dai;
		struct asoc_simple_dai codec_dai;
	} dai_links[]; /* dynamically allocated */
   };

But, as said this only an implementation detail.

Best regards,
Jyri
