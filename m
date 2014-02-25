Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752192AbaBYIBS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 03:01:18 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:41913 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751336AbaBYIBQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 03:01:16 -0500
Date: Tue, 25 Feb 2014 09:02:49 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: Re: [alsa-devel] [PATCH 2/4] ASoC: simple-card: dynamically
 allocate the DAI link array
Message-ID: <20140225090249.4e6cace9@armhf>
In-Reply-To: <397c6a465f424a3eb42ead8f1e55f7d9@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1392995566.git.moinejf@free.fr>
	<41aa7354a6883f31afa60c21c2e14ecbb3bbb7e9.1392995566.git.moinejf@free.fr>
	<397c6a465f424a3eb42ead8f1e55f7d9@BY2PR03MB505.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 03:32:02 +0000
"Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com> wrote:
> 
> > @@ -20,7 +20,6 @@ struct simple_card_data {
> >  	unsigned int daifmt;
> >  	struct asoc_simple_dai cpu_dai;
> >  	struct asoc_simple_dai codec_dai;
> > -	struct snd_soc_dai_link snd_link;
> >  };
> > 
> >  static int __asoc_simple_card_dai_init(struct snd_soc_dai *dai,
> > @@ -246,7 +245,9 @@ static int asoc_simple_card_probe(struct platform_device
> > *pdev)
> >  	struct device *dev = &pdev->dev;
> >  	int ret;
> > 
> > -	priv = devm_kzalloc(dev, sizeof(*priv), GFP_KERNEL);
> > +	priv = devm_kzalloc(dev,
> > +			sizeof(*priv) + sizeof(*dai_link),
> 
> This is okey for me.
> 
> Well, how about splitting the *priv and *dai_link into two separated
> memory blocks? As we can get the dai-link pointer via priv->snd_card.dai_link
> in other places.
> 
> IMHO, then the code will be much more simplifier and readable.

It is just a simple optimization: less calls to memory allocation and
less code (also, less TLB reload?). I will add more comments.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
