Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755743Ab3ALACK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:02:10 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:22962 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab3ALACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:02:08 -0500
Date: Sat, 12 Jan 2013 03:01:52 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Cyril Roelandt <tipecaml@gmail.com>,
        spi-devel-general@lists.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] spi: fix return value check in hspi_probe().
Message-ID: <20130112000152.GX7247@mwanda>
References: <1355271894-5284-1-git-send-email-tipecaml@gmail.com>
 <1355271894-5284-6-git-send-email-tipecaml@gmail.com>
 <87txrsqf7f.wl%kuninori.morimoto.gx@renesas.com>
 <20121219151154.937EC3E0AD7@localhost>
 <20121219163914.GN5032@mwanda>
 <20121222095620.83E243E07FA@localhost>
 <20130103160455.GO7247@mwanda>
 <20130111150202.C25583E08C3@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130111150202.C25583E08C3@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 03:02:02PM +0000, Grant Likely wrote:
> On Thu, 3 Jan 2013 19:04:55 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > On Sat, Dec 22, 2012 at 09:56:20AM +0000, Grant Likely wrote:
> > > On Wed, 19 Dec 2012 19:39:14 +0300, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> > > > On Wed, Dec 19, 2012 at 03:11:54PM +0000, Grant Likely wrote:
> > > > > On Tue, 11 Dec 2012 16:36:27 -0800 (PST), Kuninori Morimoto <kuninori.morimoto.gx@renesas.com> wrote:
> > > > > > 
> > > > > > Hi
> > > > > > 
> > > > > > > According to its documentation, clk_get() returns a "valid IS_ERR() condition
> > > > > > > containing errno", so we should call IS_ERR() rather than a NULL check.
> > > > > > > 
> > > > > > > Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
> > > > > > 
> > > > > > Acked-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> > > > > 
> > > > > Applied, thanks.
> > > > 
> > > > In another thread, we were just talking about who clk_get() can
> > > > return a NULL if !CONFIG_HAVE_CLK.  That might change to match the
> > > > documentation later...  Not sure.
> > > 
> > > So what is the solution here? Will the dummy clk_get() be changed, or is
> > > there more work needed on the drivers?
> > > 
> > 
> > This driver can't function without a clk.  It should select that at
> > build time instead of testing for it at probe.  Just checking for
> > IS_ERR() will NOT cause a NULL dereference so the patch is ok in
> > that respect.  I'm not sure if this can be build without
> > CONFIG_HAVE_CLK.
> 
> Your suggestion is to make this driver depend on CONFIG_HAVE_CLK? I'm
> fine with that, but it doesn't sort out the core infrastructure question
> about whether it is valid for the empty clk_get() to return NULL. Nor is
> it a particularly sustainable solution (ie. if a large number of drivers
> want to do the same thing).
> 

We've spread this conversation out across several different threads.

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-January/139186.html

Basically, drivers should use accessor functions which handle NULL
pointers instead of dereferencing the pointer directly.

regards,
dan carpenter

