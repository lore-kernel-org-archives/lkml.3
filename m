Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752649AbaIAGgL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 02:36:11 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:22087 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752163AbaIAGgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 02:36:09 -0400
Date: Mon, 1 Sep 2014 08:37:28 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Xiubo Li <Li.Xiubo@freescale.com>
Cc: <broonie@kernel.org>, <lgirdwood@gmail.com>, <perex@perex.cz>,
        <tiwai@suse.de>, <kuninori.morimoto.gx@renesas.com>, <jsarha@ti.com>,
        <alsa-devel@alsa-project.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHv2 1/2] ASoC: simple-card: Fix bug of forgetting
 decrement DT node's refcount
Message-ID: <20140901083728.01454558@armhf>
In-Reply-To: <1409535327-11449-2-git-send-email-Li.Xiubo@freescale.com>
References: <1409535327-11449-1-git-send-email-Li.Xiubo@freescale.com>
	<1409535327-11449-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Sep 2014 09:35:26 +0800
Xiubo Li <Li.Xiubo@freescale.com> wrote:

> We shouldn't forget decrement the last DT node when the
> for_each_child_of_node() has finished searching.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
> ---
>  sound/soc/generic/simple-card.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> index fd8b045..9e170fe 100644
> --- a/sound/soc/generic/simple-card.c
> +++ b/sound/soc/generic/simple-card.c
> @@ -360,6 +360,7 @@ static int asoc_simple_card_parse_of(struct device_node *node,
>  			}
>  			i++;
>  		}
> +		of_node_put(np);
>  	} else {
>  		ret = asoc_simple_card_dai_link_of(node, dev,
>  						   dai_link, dai_props, true);

No. np is NULL at end of loop.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
