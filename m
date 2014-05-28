Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612AbaE1Vrs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 17:47:48 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:56723 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476AbaE1Vro convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 17:47:44 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tero Kristo <t-kristo@ti.com>, "Julia Lawall" <julia.lawall@lip6.fr>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <5379F7AE.2040806@ti.com>
Cc: "Dan Carpenter" <dan.carpenter@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "J Keerthy" <j-keerthy@ti.com>
References: <1400473875-22228-1-git-send-email-Julia.Lawall@lip6.fr>
 <1400473875-22228-4-git-send-email-Julia.Lawall@lip6.fr>
 <20140519074155.GO15585@mwanda> <5379BC0C.3070401@ti.com>
 <alpine.DEB.2.10.1405191924330.2564@hadrien> <5379F7AE.2040806@ti.com>
Message-ID: <20140528214739.10062.75330@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] CLK: TI: DRA7: return error code in failure case
Date: Wed, 28 May 2014 14:47:39 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tero Kristo (2014-05-19 05:23:10)
> On 05/19/2014 02:25 PM, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > Add a returned error code in the MAX_APLL_WAIT_TRIES case.  Remove the
> > updating of the return variable r to 0 if MAX_APLL_WAIT_TRIES is not yet
> > reached, because r is already 0 at this point.
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Acked-by: Tero Kristo <t-kristo@ti.com>
> 
> Mike, do you want to queue this as a fix or shall I add this to be 
> queued for 3.16?

It's not a visible regression, so let's go with 3.16.

Regards,
Mike

> 
> -Tero
> 
> >
> > ---
> > diff --git a/drivers/clk/ti/apll.c b/drivers/clk/ti/apll.c
> > index b986f61..efc71a0 100644
> > --- a/drivers/clk/ti/apll.c
> > +++ b/drivers/clk/ti/apll.c
> > @@ -77,13 +77,11 @@ static int dra7_apll_enable(struct clk_hw *hw)
> >       if (i == MAX_APLL_WAIT_TRIES) {
> >               pr_warn("clock: %s failed transition to '%s'\n",
> >                       clk_name, (state) ? "locked" : "bypassed");
> > -     } else {
> > +             r = -EBUSY;
> > +     } else
> >               pr_debug("clock: %s transition to '%s' in %d loops\n",
> >                        clk_name, (state) ? "locked" : "bypassed", i);
> >
> > -             r = 0;
> > -     }
> > -
> >       return r;
> >   }
> >
> 
