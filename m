Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751144Ab3HSJMo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 05:12:44 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:6705 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750999Ab3HSJMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 05:12:42 -0400
X-IronPort-AV: E=Sophos;i="4.89,912,1367964000"; 
   d="scan'208";a="24222439"
Date: Mon, 19 Aug 2013 11:12:21 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: walter harms <wharms@bfs.de>
cc: Liam Girdwood <lgirdwood@gmail.com>, kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] regulator: ti-abb: simplify
 platform_get_resource_byname/devm_ioremap_resource
In-Reply-To: <5211E111.4060406@bfs.de>
Message-ID: <alpine.DEB.2.02.1308191112010.2313@hadrien>
References: <1376902316-18520-1-git-send-email-Julia.Lawall@lip6.fr> <1376902316-18520-6-git-send-email-Julia.Lawall@lip6.fr> <5211E111.4060406@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013, walter harms wrote:

>
>
> Am 19.08.2013 10:51, schrieb Julia Lawall:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Remove unneeded error handling on the result of a call to
> > platform_get_resource_byname when the value is passed to devm_ioremap_resource.
> >
> > A simplified version of the semantic patch that makes this change is as
> > follows: (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > expression pdev,res,e,e1;
> > expression ret != 0;
> > identifier l;
> > @@
> >
> >   res = platform_get_resource_byname(...);
> > - if (res == NULL) { ... \(goto l;\|return ret;\) }
> >   e = devm_ioremap_resource(e1, res);
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/regulator/ti-abb-regulator.c |   10 ----------
> >  1 file changed, 10 deletions(-)
> >
> > diff --git a/drivers/regulator/ti-abb-regulator.c b/drivers/regulator/ti-abb-regulator.c
> > index 3753ed0..d8e3e12 100644
> > --- a/drivers/regulator/ti-abb-regulator.c
> > +++ b/drivers/regulator/ti-abb-regulator.c
> > @@ -717,11 +717,6 @@ static int ti_abb_probe(struct platform_device *pdev)
> >  	/* Map ABB resources */
> >  	pname = "base-address";
> >  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
> > -	if (!res) {
> > -		dev_err(dev, "Missing '%s' IO resource\n", pname);
> > -		ret = -ENODEV;
> > -		goto err;
> > -	}
> >  	abb->base = devm_ioremap_resource(dev, res);
> >  	if (IS_ERR(abb->base)) {
> >  		ret = PTR_ERR(abb->base);
>
>
> is pname used by anything else ? (also below)

I'll check.  Thanks for the feedback.

julia


>
> re,
>  wh
>
> > @@ -770,11 +765,6 @@ static int ti_abb_probe(struct platform_device *pdev)
> >
> >  	pname = "ldo-address";
> >  	res = platform_get_resource_byname(pdev, IORESOURCE_MEM, pname);
> > -	if (!res) {
> > -		dev_dbg(dev, "Missing '%s' IO resource\n", pname);
> > -		ret = -ENODEV;
> > -		goto skip_opt;
> > -	}
> >  	abb->ldo_base = devm_ioremap_resource(dev, res);
> >  	if (IS_ERR(abb->ldo_base)) {
> >  		ret = PTR_ERR(abb->ldo_base);
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
