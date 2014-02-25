Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751356AbaBYH3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 02:29:24 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:45236 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750706AbaBYH3X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 02:29:23 -0500
Date: Tue, 25 Feb 2014 08:30:56 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: "Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com>
Cc: Mark Brown <broonie@kernel.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "Kuninori Morimoto" <kuninori.morimoto.gx@renesas.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/4] ASoC: simple-card: Fix device node locks
Message-ID: <20140225083056.7bfb35f6@armhf>
In-Reply-To: <23e531e0edb34aa9b84799e558abaf26@BY2PR03MB505.namprd03.prod.outlook.com>
References: <cover.1392995566.git.moinejf@free.fr>
	<4dca81f45b67a4dcb21271e57409ba114c3b59cb.1392995566.git.moinejf@free.fr>
	<23e531e0edb34aa9b84799e558abaf26@BY2PR03MB505.namprd03.prod.outlook.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 24 Feb 2014 02:17:00 +0000
"Li.Xiubo@freescale.com" <Li.Xiubo@freescale.com> wrote:

> > @@ -169,22 +164,26 @@ static int asoc_simple_card_parse_of(struct device_node
> > *node,
> >  	/* CPU sub-node */
> >  	ret = -EINVAL;
> >  	np = of_get_child_by_name(node, "simple-audio-card,cpu");
> > -	if (np)
> > +	if (np) {
> >  		ret = asoc_simple_card_sub_parse_of(np, priv->daifmt,
> >  						  &priv->cpu_dai,
> >  						  &dai_link->cpu_of_node,
> >  						  &dai_link->cpu_dai_name);
> > +		of_node_put(np);
> 
> Does the of_node_put(np) is really needed here ?
	[snip]

Yes, of_get_child_by_name() increments the node refcount and np is not
used afterwards.

But, you are right, this creates a bug in the next patch when using
of_get_next_child(). I will fix it.

Thanks.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
