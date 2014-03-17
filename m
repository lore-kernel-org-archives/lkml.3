Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756397AbaCQKXl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 06:23:41 -0400
Received: from smtpfb2-g21.free.fr ([212.27.42.10]:44516 "EHLO
	smtpfb2-g21.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbaCQKXj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 06:23:39 -0400
Date: Mon, 17 Mar 2014 11:23:32 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jyri Sarha <jsarha@ti.com>
Cc: Mark Brown <broonie@kernel.org>, <alsa-devel@alsa-project.org>,
        Xiubo Li <Li.Xiubo@freescale.com>, <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH v3 2/4] ASoC: simple-card: dynamically
 allocate the DAI link and properties
Message-ID: <20140317112332.4a0700d8@armhf>
In-Reply-To: <5326C086.6080609@ti.com>
References: <cover.1394883134.git.moinejf@free.fr>
	<1cf50fea2306bcb05987533042dbf1495b2c6f07.1394883134.git.moinejf@free.fr>
	<5326C086.6080609@ti.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Mar 2014 11:29:42 +0200
Jyri Sarha <jsarha@ti.com> wrote:

> On 03/15/2014 01:09 PM, Jean-Francois Moine wrote:
> > The DAI link array and the properties (fmt, sysclk slots) are
> > hard-coded for a single CPU / CODEC link.
> >
> > This patch dynamically allocates the DAI link array and the
> > properties with the aim of supporting many DAI links.
> >
> > Signed-off-by: Jean-Francois Moine <moinejf@free.fr>
> > ---
> >   sound/soc/generic/simple-card.c | 49 +++++++++++++++++++++++++----------------
> >   1 file changed, 30 insertions(+), 19 deletions(-)
> >
> > diff --git a/sound/soc/generic/simple-card.c b/sound/soc/generic/simple-card.c
> > index ca7e63e..a55dc46 100644
> > --- a/sound/soc/generic/simple-card.c
> > +++ b/sound/soc/generic/simple-card.c
> > @@ -20,9 +20,11 @@
> >
> >   struct simple_card_data {
> >   	struct snd_soc_card snd_card;
> > -	struct asoc_simple_dai cpu_dai;
> > -	struct asoc_simple_dai codec_dai;
> > -	struct snd_soc_dai_link snd_link;
> > +	struct simple_dais {
> > +		struct asoc_simple_dai cpu_dai;
> > +		struct asoc_simple_dai codec_dai;
> > +	} *dais;
> > +	struct snd_soc_dai_link dai_link[];	/* dynamically allocated */
> >   };
> >
> 
> This is only an implementation detail, but wouldn't it produce a cleaner 
> implementation if you would write the above structure like this:
> 
>    struct simple_card_data {
>    	struct snd_soc_card snd_card;
> 	struct simple_dai_links {
> 		struct snd_soc_dai_link dai_link;
> 		struct asoc_simple_dai cpu_dai;
> 		struct asoc_simple_dai codec_dai;
> 	} *dai_links;
>    };
> 
> or even
> 
>    struct simple_card_data {
>    	struct snd_soc_card snd_card;
> 	struct simple_dai_links {
> 		struct snd_soc_dai_link dai_link;
> 		struct asoc_simple_dai cpu_dai;
> 		struct asoc_simple_dai codec_dai;
> 	} dai_links[]; /* dynamically allocated */
>    };
> 
> But, as said this only an implementation detail.

Jyri,

No, this would not work. The DAI link in the struct snd_soc_card is an
array of struct snd_soc_dai_link. There cannot be anything between the
elements!

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
