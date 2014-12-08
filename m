Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008AbaLHHLx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2014 02:11:53 -0500
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:42984 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751969AbaLHHLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2014 02:11:51 -0500
X-IronPort-AV: E=Sophos;i="5.07,536,1413237600"; 
   d="scan'208";a="111973841"
Date: Mon, 8 Dec 2014 08:11:48 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Richard Weinberger <richard.weinberger@gmail.com>
cc: Julia Lawall <Julia.Lawall@lip6.fr>, Kukjin Kim <kgene@kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        linux@rasmusvillemoes.dk, Joe Perches <joe@perches.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc@vger.kernel.org,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/20] mtd: s3c2410: fix misspelling of current function
 in string
In-Reply-To: <CAFLxGvyiqxQ6U6p-A-JW8Nv8OvXFGsna93afUu-Gek0EV3gATA@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1412080809400.2100@localhost6.localdomain6>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr> <1417980062-25151-2-git-send-email-Julia.Lawall@lip6.fr> <CAFLxGvyiqxQ6U6p-A-JW8Nv8OvXFGsna93afUu-Gek0EV3gATA@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > diff --git a/drivers/mtd/nand/s3c2410.c b/drivers/mtd/nand/s3c2410.c
> > index 35aef5e..0a9c41f 100644
> > --- a/drivers/mtd/nand/s3c2410.c
> > +++ b/drivers/mtd/nand/s3c2410.c
> > @@ -948,7 +948,7 @@ static int s3c24xx_nand_probe(struct platform_device *pdev)
> >
> >         cpu_type = platform_get_device_id(pdev)->driver_data;
> >
> > -       pr_debug("s3c2410_nand_probe(%p)\n", pdev);
> > +       pr_debug("%s(%p)\n", __func__, pdev);
> 
> I think we can drop the line completely.
> We have ftrace to trace function calls...

Should the "initialised ok" at the end of the function be remove as well?

Will it be confusing if this cleanup is done in this function, but not in 
others where it may be useful?  Perhaps s3c2410_nand_update_chip, for 
example?

julia
