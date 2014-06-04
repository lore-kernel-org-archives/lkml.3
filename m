Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753887AbaFDPK2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 11:10:28 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:15545
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751510AbaFDPKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 11:10:25 -0400
X-IronPort-AV: E=Sophos;i="4.98,973,1392159600"; 
   d="scan'208";a="65448152"
Date: Wed, 4 Jun 2014 17:10:17 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: scameron@beardog.cce.hp.com
cc: linux-kernel@vger.kernel.org, axboe@kernel.dk
Subject: Re: [PATCH 7/10] cciss: use safer test on the result of
 find_first_zero_bit
In-Reply-To: <20140604145135.GC6970@beardog.cce.hp.com>
Message-ID: <alpine.DEB.2.10.1406041709500.2441@hadrien>
References: <20140604145135.GC6970@beardog.cce.hp.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 4 Jun 2014, scameron@beardog.cce.hp.com wrote:

> > Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
> > return a larger number than the maximum position argument if that position
> > is not a multiple of BITS_PER_LONG.
> >
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> >
> > // <smpl>
> > @@
> > expression e1,e2,e3;
> > statement S1,S2;
> > @@
> >
> > e1 = find_first_zero_bit(e2,e3)
> > ...
> > if (e1
> > - ==
> > + >=
> >   e3)
> > S1 else S2
> > // </smpl>
> >
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> >
> > ---
> >  drivers/block/cciss.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff -u -p a/drivers/block/cciss.c b/drivers/block/cciss.c
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -980,7 +980,7 @@ static CommandList_struct *cmd_alloc(ctl
> >
> >  	do {
> >  		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
> > -		if (i == h->nr_cmds)
> > +		if (i >= h->nr_cmds)
> >  			return NULL;
> >  	} while (test_and_set_bit(i, h->cmd_pool_bits) != 0);
> >  	c = h->cmd_pool + i;
>
>
> Thanks. Ack.
>
> You can add
>
> Reviewed-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
>
> to this patch if you want.
>
> You might consider adding "Cc: stable@vger.kernel.org" into the
> sign-off area as well.

Likewise here, the change is not needed.

julia
