Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992487AbaEQHMJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 03:12:09 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:58887 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S2992439AbaEQHMI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 03:12:08 -0400
X-IronPort-AV: E=Sophos;i="4.98,1071,1392159600"; 
   d="scan'208";a="74201384"
Date: Sat, 17 May 2014 15:12:02 +0800 (SGT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Fabio Estevam <festevam@gmail.com>
cc: David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] mtd: delete unneeded call to platform_get_drvdata
In-Reply-To: <CAOMZO5AymcCnC6Awt2LiGP9yz=baRA0HLoLRUSBgNeg3b5=9xQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1405171511140.2587@hadrien>
References: <1400308369-24375-1-git-send-email-Julia.Lawall@lip6.fr> <CAOMZO5AymcCnC6Awt2LiGP9yz=baRA0HLoLRUSBgNeg3b5=9xQ@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 17 May 2014, Fabio Estevam wrote:

> On Sat, May 17, 2014 at 3:32 AM, Julia Lawall <Julia.Lawall@lip6.fr> wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Platform_get_drvdata is an accessor function, and has no purpose if its
> > result is not used.
> >
> > The semantic patch that fixes this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > identifier x;
> > type T;
> > @@
> > - T x = platform_get_drvdata(...);
> > ... when != x
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/mtd/nand/bf5xx_nand.c |    4 ----
> >  1 file changed, 4 deletions(-)
> >
> > diff --git a/drivers/mtd/nand/bf5xx_nand.c b/drivers/mtd/nand/bf5xx_nand.c
> > index b7a2494..b5fbd48 100644
> > --- a/drivers/mtd/nand/bf5xx_nand.c
> > +++ b/drivers/mtd/nand/bf5xx_nand.c
> > @@ -840,15 +840,11 @@ out_err_kzalloc:
> >
> >  static int bf5xx_nand_suspend(struct platform_device *dev, pm_message_t pm)
> >  {
> > -       struct bf5xx_nand_info *info = platform_get_drvdata(dev);
> > -
> >         return 0;
> >  }
> >
> >  static int bf5xx_nand_resume(struct platform_device *dev)
> >  {
> > -       struct bf5xx_nand_info *info = platform_get_drvdata(dev);
> > -
> >         return 0;
>
> In this case bf5xx_nand_suspend/resume could be removed?

I don't know.  It looks like it is intentional to have a definition that
returns an indication of success?  The complete set of definitions is:

#ifdef CONFIG_PM

static int bf5xx_nand_suspend(struct platform_device *dev, pm_message_t
pm)
{
        struct bf5xx_nand_info *info = platform_get_drvdata(dev);

	return 0;
}

static int bf5xx_nand_resume(struct platform_device *dev)
{
        struct bf5xx_nand_info *info = platform_get_drvdata(dev);

        return 0;
}

#else
#define bf5xx_nand_suspend NULL
#define bf5xx_nand_resume NULL
#endif

julia
