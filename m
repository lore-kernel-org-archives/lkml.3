Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281Ab3AVKLC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 05:11:02 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:45207 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449Ab3AVKLA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 05:11:00 -0500
Date: Tue, 22 Jan 2013 10:10:53 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Rob Herring <robherring2@gmail.com>, Vinod Koul <vinod.koul@intel.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] of: dma.c: fix memory leakage
Message-ID: <20130122101053.GA2427@gmail.com>
References: <1358600805-20193-1-git-send-email-dinggnu@gmail.com>
 <50FC6EB1.4050704@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50FC6EB1.4050704@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 20, 2013 at 04:24:49PM -0600, Rob Herring wrote:
> On 01/19/2013 07:06 AM, Cong Ding wrote:
> > The memory allocated to ofdma might be a leakage when error occurs.
> > 
> > Signed-off-by: Cong Ding <dinggnu@gmail.com>
> 
> You need to send this to whomever is working on DMA bindings.
Thank you bob, I added Vinod the the receiver list.

- cong

> 
> > ---
> >  drivers/of/dma.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/of/dma.c b/drivers/of/dma.c
> > index 59631b2..583e50e3 100644
> > --- a/drivers/of/dma.c
> > +++ b/drivers/of/dma.c
> > @@ -107,6 +107,7 @@ int of_dma_controller_register(struct device_node *np,
> >  	if (!nbcells) {
> >  		pr_err("%s: #dma-cells property is missing or invalid\n",
> >  		       __func__);
> > +		kfree(ofdma);
> >  		return -EINVAL;
> >  	}
> >  
> > 
