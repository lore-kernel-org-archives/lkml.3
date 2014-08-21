Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754373AbaHUKSd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 06:18:33 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:26456 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754189AbaHUKS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 06:18:27 -0400
X-IronPort-AV: E=Sophos;i="5.01,908,1400018400"; 
   d="scan'208";a="90240673"
Date: Thu, 21 Aug 2014 05:18:21 -0500 (CDT)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Lee Jones <lee.jones@linaro.org>
cc: Samuel Ortiz <sameo@linux.intel.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mfd: menelaus: fix error return code
In-Reply-To: <20140821082605.GS4266@lee--X1>
Message-ID: <alpine.DEB.2.10.1408210517570.2534@hadrien>
References: <1407355938-10932-2-git-send-email-Julia.Lawall@lip6.fr> <20140821082605.GS4266@lee--X1>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 21 Aug 2014, Lee Jones wrote:

> On Wed, 06 Aug 2014, Julia Lawall wrote:
>
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Convert a zero return value on error to a negative one, as returned
> > elsewhere in the function.
> >
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > (
> > if@p1 (\(ret < 0\|ret != 0\))
> >  { ... return ret; }
> > |
> > ret@p1 = 0
> > )
> > ... when != ret = e1
> >     when != &ret
> > *if(...)
> > {
> >   ... when != ret = e2
> >       when forall
> >  return ret;
> > }
> >
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/mfd/menelaus.c |    4 +++-
> >  1 file changed, 3 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/mfd/menelaus.c b/drivers/mfd/menelaus.c
> > index 5e2667a..16070d8 100644
> > --- a/drivers/mfd/menelaus.c
> > +++ b/drivers/mfd/menelaus.c
> > @@ -1240,8 +1240,10 @@ static int menelaus_probe(struct i2c_client *client,
> >  	pr_info("Menelaus rev %d.%d\n", rev >> 4, rev & 0x0f);
> >
> >  	val = menelaus_read_reg(MENELAUS_VCORE_CTRL1);
> > -	if (val < 0)
> > +	if (val < 0) {
> > +		err = val;
> >  		goto fail;
> > +	}
>
> I'd prefer it if you could s/val/err and remove val altogether.  While
> you're there, if you can s/(1 << 7)/BIT(7), that would be great
> too.  If you don't have time, or just don't want to do it, I will be
> happy to submit a patch instead with your Reported-by.  Your call.
>
> >  	if (val & (1 << 7))
> >  		menelaus->vcore_hw_mode = 1;
> >  	else
> >

I will look into it.  Thanks for the feedback.

julia
