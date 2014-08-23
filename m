Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751810AbaHWPcl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 11:32:41 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:40765 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750886AbaHWPcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 11:32:39 -0400
X-IronPort-AV: E=Sophos;i="5.04,386,1406584800"; 
   d="scan'208";a="90875967"
Date: Sat, 23 Aug 2014 17:32:37 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Josh Triplett <josh@joshtriplett.org>
cc: Paul Mackerras <paulus@samba.org>, kernel-janitors@vger.kernel.org,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>, linux-fbdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] video: fbdev: aty: use c99 initializers in
 structures
In-Reply-To: <20140823152015.GB2074@thin>
Message-ID: <alpine.DEB.2.02.1408231731550.2068@localhost6.localdomain6>
References: <1408792831-25615-1-git-send-email-Julia.Lawall@lip6.fr> <1408792831-25615-9-git-send-email-Julia.Lawall@lip6.fr> <20140823152015.GB2074@thin>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, 23 Aug 2014, Josh Triplett wrote:

> On Sat, Aug 23, 2014 at 01:20:30PM +0200, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Use c99 initializers for structures.
> > 
> > A simplified version of the semantic match that finds this problem is as
> > follows: (http://coccinelle.lip6.fr/)
> > 
> > // <smpl>
> > @decl@
> > identifier i1,fld;
> > type T;
> > field list[n] fs;
> > @@
> > 
> > struct i1 {
> >  fs
> >  T fld;
> >  ...};
> > 
> > @bad@
> > identifier decl.i1,i2;
> > expression e;
> > initializer list[decl.n] is;
> > @@
> > 
> > struct i1 i2 = { is,
> > + .fld = e
> > - e
> >  ,...};
> > // </smpl>
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> One comment below about formatting.  With that addressed:
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> 
> > --- a/drivers/video/fbdev/aty/aty128fb.c
> > +++ b/drivers/video/fbdev/aty/aty128fb.c
> > @@ -324,14 +324,57 @@ struct aty128_meminfo {
> >  };
> >  
> >  /* various memory configurations */
> > -static const struct aty128_meminfo sdr_128   =
> > -	{ 4, 4, 3, 3, 1, 3, 1, 16, 30, 16, "128-bit SDR SGRAM (1:1)" };
> > -static const struct aty128_meminfo sdr_64    =
> > -	{ 4, 8, 3, 3, 1, 3, 1, 17, 46, 17, "64-bit SDR SGRAM (1:1)" };
> > -static const struct aty128_meminfo sdr_sgram =
> > -	{ 4, 4, 1, 2, 1, 2, 1, 16, 24, 16, "64-bit SDR SGRAM (2:1)" };
> > -static const struct aty128_meminfo ddr_sgram =
> > -	{ 4, 4, 3, 3, 2, 3, 1, 16, 31, 16, "64-bit DDR SGRAM" };
> > +static const struct aty128_meminfo sdr_128 = {
> > +	.ML = 4,
> > +	.MB = 4,
> > +	.Trcd = 3,
> > +	.Trp = 3,
> > +	.Twr = 1,
> > +	.CL = 3,
> > +	.Tr2w = 1,
> > +	.LoopLatency = 16,
> > +	.DspOn = 30,
> > +	.Rloop = 16,
> > +	.name = "128-bit SDR SGRAM (1:1)" };
> 
> The closing brace should be in column 0 of the next line.  Also, the
> final field initializer should have a comma after it. (Likewise for the
> remaining changes in this file.)

In general, I haven't changed the presence or absence of trailing commas.  
Should I add them everywhere?

julia
