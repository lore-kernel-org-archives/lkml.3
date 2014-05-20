Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873AbaETJQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 05:16:19 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:21615 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752237AbaETJQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 05:16:15 -0400
Date: Tue, 20 May 2014 12:15:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Fabio Estevam <festevam@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        kernel-janitors@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/2] mtd: delete unneeded call to platform_get_drvdata
Message-ID: <20140520091526.GF15585@mwanda>
References: <1400308369-24375-1-git-send-email-Julia.Lawall@lip6.fr>
 <CAOMZO5AymcCnC6Awt2LiGP9yz=baRA0HLoLRUSBgNeg3b5=9xQ@mail.gmail.com>
 <alpine.DEB.2.10.1405171511140.2587@hadrien>
 <20140520083531.GH2413@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140520083531.GH2413@norris-Latitude-E6410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 01:35:31AM -0700, Brian Norris wrote:
> > > >  static int bf5xx_nand_resume(struct platform_device *dev)
> > > >  {
> > > > -       struct bf5xx_nand_info *info = platform_get_drvdata(dev);
> > > > -
> > > >         return 0;
> > >
> > > In this case bf5xx_nand_suspend/resume could be removed?
> > 
> > I don't know.  It looks like it is intentional to have a definition that
> > returns an indication of success?  The complete set of definitions is:
> 
> I'm not so sure. I believe suspend/resume works just fine without the
> hooks, if those hooks would otherwise be doing nothing. It is notable
> that this driver is not using the modern dev_pm_ops form of the
> suspend/resume callbacks, so maybe it just hasn't aged gracefully--and
> possibly was never supported properly in the first place.
> 

These are called from platform_legacy_suspend/platform_legacy_resume.
It looks like the functions are not needed.

(I am not an expert on pm, I just querried my Smatch Cross Function
Database which is awesome).

regards,
dan carpenter

